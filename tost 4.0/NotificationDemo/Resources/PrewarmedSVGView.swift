import Combine
import SwiftUI
import WebKit

struct PrewarmedSVGView: View {
    let svg: String
    let size: CGSize

    @ObservedObject private var snapshotStore = InlineSVGSnapshotStore.shared

    var body: some View {
        Group {
            if let image = snapshotStore.image(for: svg) {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.high)
            } else {
                InlineSVGWebView(svg: svg)
            }
        }
        .frame(width: size.width, height: size.height)
        .onAppear {
            snapshotStore.warm(svg: svg, size: size)
        }
    }
}

@MainActor
final class InlineSVGSnapshotStore: ObservableObject {
    static let shared = InlineSVGSnapshotStore()

    @Published private var cachedImages: [String: UIImage] = [:]
    private var loadingKeys = Set<String>()
    private var activeLoaders: [String: Loader] = [:]

    private init() {}

    func image(for svg: String) -> UIImage? {
        cachedImages[svg]
    }

    func warm(svg: String, size: CGSize) {
        guard !svg.isEmpty else { return }
        guard cachedImages[svg] == nil else { return }
        guard !loadingKeys.contains(svg) else { return }

        let loader = Loader(
            svg: svg,
            size: size,
            onImageReady: { [weak self] image in
                Task { @MainActor in
                    self?.cachedImages[svg] = image
                    self?.loadingKeys.remove(svg)
                    self?.activeLoaders[svg] = nil
                }
            },
            onFailure: { [weak self] in
                Task { @MainActor in
                    self?.loadingKeys.remove(svg)
                    self?.activeLoaders[svg] = nil
                }
            }
        )

        loadingKeys.insert(svg)
        activeLoaders[svg] = loader
        loader.start()
    }

    func waitUntilReady(for svg: String, timeoutNanoseconds: UInt64) async {
        guard !svg.isEmpty else { return }
        guard cachedImages[svg] == nil else { return }

        let deadline = Date().timeIntervalSince1970 + (Double(timeoutNanoseconds) / 1_000_000_000)
        while cachedImages[svg] == nil && loadingKeys.contains(svg) {
            if Date().timeIntervalSince1970 >= deadline {
                break
            }

            try? await Task.sleep(nanoseconds: 25_000_000)
        }
    }

    private final class Loader: NSObject, WKNavigationDelegate {
        let svg: String
        let size: CGSize
        let onImageReady: (UIImage) -> Void
        let onFailure: () -> Void

        private lazy var webView: WKWebView = {
            let configuration = WKWebViewConfiguration()
            let webView = WKWebView(frame: CGRect(origin: .zero, size: size), configuration: configuration)
            webView.isOpaque = false
            webView.backgroundColor = .clear
            if #available(iOS 15.0, *) {
                webView.underPageBackgroundColor = .clear
            }
            webView.scrollView.isScrollEnabled = false
            webView.scrollView.isOpaque = false
            webView.scrollView.backgroundColor = .clear
            webView.layer.backgroundColor = UIColor.clear.cgColor
            webView.isUserInteractionEnabled = false
            webView.navigationDelegate = self
            return webView
        }()

        init(
            svg: String,
            size: CGSize,
            onImageReady: @escaping (UIImage) -> Void,
            onFailure: @escaping () -> Void
        ) {
            self.svg = svg
            self.size = size
            self.onImageReady = onImageReady
            self.onFailure = onFailure
        }

        func start() {
            webView.loadHTMLString(makeInlineSVGHTML(svg), baseURL: nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 50_000_000)

                let snapshotConfiguration = WKSnapshotConfiguration()
                snapshotConfiguration.rect = CGRect(origin: .zero, size: size)
                webView.takeSnapshot(with: snapshotConfiguration) { [onImageReady, onFailure] image, _ in
                    guard let image else {
                        onFailure()
                        return
                    }

                    onImageReady(image)
                }
            }
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            onFailure()
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            onFailure()
        }
    }
}

func makeInlineSVGHTML(_ svg: String) -> String {
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
        html, body {
          margin: 0;
          width: 100%;
          height: 100%;
          background: transparent;
          overflow: hidden;
          font-family: "SF Pro Display", "SF Pro Text", -apple-system, BlinkMacSystemFont, "Helvetica Neue", sans-serif;
        }

        svg {
          display: block;
          width: 100%;
          height: 100%;
        }

        svg, text, tspan, div, span, p, foreignObject {
          font-family: "SF Pro Display", "SF Pro Text", -apple-system, BlinkMacSystemFont, "Helvetica Neue", sans-serif !important;
          -webkit-font-smoothing: antialiased;
          text-rendering: geometricPrecision;
        }
      </style>
    </head>
    <body>
    \(svg)
    </body>
    </html>
    """
}
