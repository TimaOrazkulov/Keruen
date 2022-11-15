import UIKit

// MARK: - BaseViewController

open class BaseViewController: UIViewController {
    override open var prefersStatusBarHidden: Bool { false }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - BaseViewController + Messages

extension BaseViewController {
    public func showError(with message: String) {

    }

    public func showError(_ error: Error) {

    }

    private func showInternalError(with message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(title: "Close", style: .default)
        )

        present(alertController, animated: true)
    }
}

// MARK: - BaseViewController + StatusBarHeight

extension BaseViewController {
    public var statusBarHeight: CGFloat {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        return keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}

// MARK: - BaseViewController + NavigationBarHeight

extension BaseViewController {
    public var navigationBarHeight: CGFloat {
        navigationController?.navigationBar.frame.height ?? 0
    }

    public var defaultNavigationBarHeight: CGFloat {
        44.0
    }
}
