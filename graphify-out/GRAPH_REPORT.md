# Graph Report - Toast  (2026-05-28)

## Corpus Check
- 49 files · ~51,094 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 472 nodes · 686 edges · 40 communities (28 shown, 12 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 24 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `afdc55d9`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]

## God Nodes (most connected - your core abstractions)
1. `GlassMorphNotificationView` - 29 edges
2. `ContentView` - 26 edges
3. `NotificationDemoViewModel` - 21 edges
4. `LoadID` - 14 edges
5. `NotificationCandidatePreset` - 12 edges
6. `NotificationSelectionEngine` - 10 edges
7. `ShimmerBlockView` - 9 edges
8. `Coordinator` - 9 edges
9. `NotificationContentFactory` - 9 edges
10. `NotificationAnimationController` - 8 edges

## Surprising Connections (you probably didn't know these)
- `loadHomeSVG()` --calls--> `loadNotificationSVG()`  [INFERRED]
  tost 4.0/NotificationDemo/Resources/HomeAssetLoader.swift → tost 4.0/NotificationDemo/Resources/NotificationResourceLoader.swift
- `loadNotificationCenterSVG()` --calls--> `loadNotificationSVG()`  [INFERRED]
  tost 4.0/NotificationDemo/Resources/NotificationCenterAssetLoader.swift → tost 4.0/NotificationDemo/Resources/NotificationResourceLoader.swift
- `loadPushStatusSVG()` --calls--> `loadNotificationSVG()`  [INFERRED]
  tost 4.0/NotificationDemo/Resources/PushStatusSVGs.swift → tost 4.0/NotificationDemo/Resources/NotificationResourceLoader.swift
- `loadEventStatusSVG()` --calls--> `loadNotificationSVG()`  [INFERRED]
  tost 4.0/NotificationDemo/Resources/EventStatusSVGs.swift → tost 4.0/NotificationDemo/Resources/NotificationResourceLoader.swift
- `loadHomeImage()` --calls--> `loadNotificationImage()`  [INFERRED]
  tost 4.0/NotificationDemo/Resources/HomeAssetLoader.swift → tost 4.0/NotificationDemo/Resources/NotificationResourceLoader.swift

## Communities (40 total, 12 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.07
Nodes (18): NotificationBellFilledShape, NotificationBellOutlineShape, FooterHighlightShape, FooterLayout, NotificationEventTailSideStrokeShape, NotificationFooterView, NotificationSurfaceAccent, NotificationSurfaceShape (+10 more)

### Community 1 - "Community 1"
Cohesion: 0.07
Nodes (15): NSObject, Loader, makeInlineSVGHTML(), PrewarmedSVGView, AllActionsIconView, Coordinator, InlineSVGWebView, PassThroughOverlayWindow (+7 more)

### Community 3 - "Community 3"
Cohesion: 0.14
Nodes (3): NotificationDemoState, NotificationDemoViewModel, Equatable

### Community 4 - "Community 4"
Cohesion: 0.12
Nodes (16): loadEventStatusSVG(), normalizeEventForegroundStyle(), removeEventGlassEffects(), loadHomeImage(), loadHomeSVG(), loadNotificationCenterSVG(), loadNotificationImage(), loadNotificationSVG() (+8 more)

### Community 5 - "Community 5"
Cohesion: 0.08
Nodes (15): ButtonStyle, NotificationCandidateCardView, DemoPanelBackground, DemoPrimaryButtonStyle, DemoSecondaryButtonStyle, NotificationDemoBackground, NotificationDemoIsolatedPreview, NotificationDemoIsolatedPreviewLayout (+7 more)

### Community 6 - "Community 6"
Cohesion: 0.14
Nodes (9): EventNotificationLayout, EventNotificationView, InAppNotificationView, Layout, Layout, NotificationContentFactory, NotificationPresentationMetrics, PushNotificationLayout (+1 more)

### Community 7 - "Community 7"
Cohesion: 0.08
Nodes (5): BottomPinchedMask, GlassMorphNotificationStyle, GlassMorphNotificationView, NotificationGlassMotionPreset, NotificationCandidateCatalog

### Community 8 - "Community 8"
Cohesion: 0.10
Nodes (5): NotificationAnimationController, NotificationDemoHomeBridge, NotificationSelectionStore, ObservableObject, InlineSVGSnapshotStore

### Community 10 - "Community 10"
Cohesion: 0.11
Nodes (18): Direction, down, up, extractEmbeddedNotificationCenterImage(), NotificationCenterAnchorTarget, important, useful, NotificationCenterBackButtonVisual (+10 more)

### Community 11 - "Community 11"
Cohesion: 0.17
Nodes (18): NotificationBellBubbleBackgroundVisual, NotificationBellBubbleVisual, NotificationBellCriticalGlyphVisual, NotificationBellFilledGlyphVisual, NotificationBellGlyphVisual, NotificationBellOutlineGlyphVisual, NotificationBellVisual, AccountsView (+10 more)

### Community 13 - "Community 13"
Cohesion: 0.50
Nodes (3): CommunicationBackBubbleButton, CommunicationPlaceholderBlock, CommunicationPlaceholderView

### Community 14 - "Community 14"
Cohesion: 0.17
Nodes (12): LoadID, accounts, actionCreate, actionInvoice, actionUpload, badge0, badge1, badge2 (+4 more)

### Community 15 - "Community 15"
Cohesion: 0.22
Nodes (7): CaseIterable, NotificationPreviewMode, homeContext, isolated, NotificationDisplayMode, multiple, single

### Community 16 - "Community 16"
Cohesion: 0.13
Nodes (10): Animatable, LiquidBackgroundView, LiquidNotificationButton, LiquidNotificationButton_Previews, LiquidNotificationConfig, PreviewHost, NotificationFooterView_Previews, PreviewProvider (+2 more)

### Community 18 - "Community 18"
Cohesion: 0.25
Nodes (8): NotificationCandidatePreset, multipleInApp, multiplePush, multipleStack, onlyStack, pushAndInApp, stackAndPush, stackPushInApp

### Community 19 - "Community 19"
Cohesion: 0.18
Nodes (11): Hashable, Detail, EventNotificationContent, InAppNotificationContent, NotificationPayload, event, inApp, push (+3 more)

### Community 20 - "Community 20"
Cohesion: 0.29
Nodes (6): NotificationCandidate, NotificationCandidateSource, criticalPush, inApp, stackEvent, String

### Community 21 - "Community 21"
Cohesion: 0.40
Nodes (4): colors, info, author, version

### Community 22 - "Community 22"
Cohesion: 0.40
Nodes (4): images, info, author, version

### Community 23 - "Community 23"
Cohesion: 0.40
Nodes (4): Identifiable, NotificationScenario, NotificationCenterCardModel, NotificationCenterSummaryCardModel

### Community 24 - "Community 24"
Cohesion: 0.40
Nodes (4): NotificationAction, Style, primary, secondary

### Community 25 - "Community 25"
Cohesion: 0.40
Nodes (4): NotificationKind, event, inApp, push

### Community 27 - "Community 27"
Cohesion: 0.40
Nodes (3): PreferenceKey, CompanyHeaderMinYPreferenceKey, NotificationCenterSectionContentOffsetPreferenceKey

### Community 28 - "Community 28"
Cohesion: 0.40
Nodes (4): AccountingInsightCard, AccountingSectionTitleView, AccountingSectionView, Layout

### Community 29 - "Community 29"
Cohesion: 0.40
Nodes (4): CompactAvatarView, CompactBellView, CompactCompanyHeaderView, Layout

### Community 30 - "Community 30"
Cohesion: 0.50
Nodes (3): info, author, version

### Community 31 - "Community 31"
Cohesion: 0.50
Nodes (3): AppRootTab, demo, home

### Community 34 - "Community 34"
Cohesion: 0.67
Nodes (3): CompanyHeaderDisplayMode, compact, regular

## Knowledge Gaps
- **72 isolated node(s):** `important`, `useful`, `up`, `down`, `pill` (+67 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LoadID` connect `Community 14` to `Community 11`, `Community 20`, `Community 15`?**
  _High betweenness centrality (0.187) - this node is a cross-community bridge._
- **Why does `GlassMorphNotificationView` connect `Community 7` to `Community 11`?**
  _High betweenness centrality (0.130) - this node is a cross-community bridge._
- **Why does `NotificationDemoView` connect `Community 5` to `Community 11`?**
  _High betweenness centrality (0.119) - this node is a cross-community bridge._
- **What connects `important`, `useful`, `up` to the rest of the system?**
  _72 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.0743321718931475 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.06882591093117409 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._