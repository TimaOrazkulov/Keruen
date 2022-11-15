import FloatingPanel
import SnapKit
import UIKit

class BaseFloatingPanelContentViewController: BaseViewController {
    private(set) var scrollView: UIScrollView?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
