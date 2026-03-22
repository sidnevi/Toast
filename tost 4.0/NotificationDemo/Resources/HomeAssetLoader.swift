import UIKit

func loadHomeSVG(named name: String) -> String {
    loadNotificationSVG(named: name, from: .homeAssets)
}

func loadHomeImage(named name: String, ext: String = "png") -> UIImage? {
    loadNotificationImage(named: name, from: .homeAssets, ext: ext)
}
