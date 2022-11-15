import FloatingPanel
import UIKit

public class AdaptiveFloatingPanelLayout: FloatingPanelLayout {
    private let contentLayout: UILayoutGuide

    public init(contentLayout: UILayoutGuide) {
        self.contentLayout = contentLayout
    }

    public var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        [
            .full: FloatingPanelAdaptiveLayoutAnchor(
                fractionalOffset: 0,
                contentLayout: contentLayout,
                referenceGuide: .superview
            )
        ]
    }

    public func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        0.8
    }

    public var initialState: FloatingPanelState {
        .full
    }

    public var position: FloatingPanelPosition {
        .bottom
    }
}
