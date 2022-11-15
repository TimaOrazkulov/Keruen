import UIKit

// MARK: - Presentable

public protocol Presentable {
    func toPresent() -> UIViewController
}

// MARK: - UIViewController + Presentable

extension UIViewController: Presentable {
    public func toPresent() -> UIViewController {
        self
    }
}
