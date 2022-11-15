import FloatingPanel
import UIKit

// MARK: - Router

public final class Router: NSObject {
    private unowned let navigationController: UINavigationController

    private var completions: [UIViewController: () -> Void] = [:]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()

        self.navigationController.delegate = self
    }

    public func present(
        _ module: Presentable,
        animated: Bool = true,
        modalPresentationStyle: UIModalPresentationStyle = .automatic
    ) {
        let controller = module.toPresent()
        controller.modalPresentationStyle = modalPresentationStyle
        navigationController.present(controller, animated: animated)
    }

    public func presentFloatingPanel(
        contentViewController: Presentable,
        isSwipable: Bool = true,
        layout: FloatingPanelLayout = FullFloatingPanelLayout(),
        cornerRadius: CGFloat = 12,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let floatingPanelController = makeFloatingPanelController(
            layout: layout,
            isSwipable: isSwipable,
            cornerRadius: cornerRadius
        )
        floatingPanelController.set(contentViewController: contentViewController.toPresent())

        if let floatingPanelContentViewController = contentViewController as? BaseFloatingPanelContentViewController {
            if let scrollView = floatingPanelContentViewController.scrollView {
                floatingPanelController.track(scrollView: scrollView)
            }
        }

        completions[floatingPanelController] = completion

        navigationController.present(floatingPanelController, animated: animated)
    }

    public func push(
        _ module: Presentable,
        animated: Bool = true,
        hideBottomBarWhenPushed: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let controller = module.toPresent()
        guard controller is UINavigationController == false else {
            return
        }

        trackScrollViewIfExists(controller: controller)
        if let completion = completion {
            completions[controller] = completion
        }

        controller.hidesBottomBarWhenPushed = hideBottomBarWhenPushed
        navigationController.pushViewController(controller, animated: animated)
    }

    public func remove(_ module: Presentable) {
        guard let index = navigationController.viewControllers.firstIndex(of: module.toPresent()) else {
            return
        }

        let viewController = navigationController.viewControllers.remove(at: index)
        completions.removeValue(forKey: viewController)
    }

    public func popModule(animated: Bool = true) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }

        if let topViewController = navigationController.topViewController {
            trackScrollViewIfExists(controller: topViewController)
        }
    }

    public func popToModule(_ module: Presentable, animated: Bool = true) {
        guard
            let controllers = navigationController.popToViewController(
                module.toPresent(),
                animated: animated
            )
        else {
            return
        }

        if let topViewController = navigationController.topViewController {
            trackScrollViewIfExists(controller: topViewController)
        }
        controllers.forEach { runCompletion(for: $0) }
    }

    public func dismissModule(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let presentedViewController = navigationController.presentedViewController else {
            return
        }

        if let completion {
            completions[presentedViewController] = completion
        }

        navigationController.dismiss(animated: animated) { [weak self] in
            self?.runCompletion(for: presentedViewController)
        }
    }

    public func setRootModule(_ module: Presentable, animated: Bool = true) {
        let controller = module.toPresent()
        trackScrollViewIfExists(controller: controller)
        navigationController.setViewControllers([controller], animated: animated)
    }

    public func popToRootModule(animated: Bool = true) {
        guard let controllers = navigationController.popToRootViewController(animated: animated) else {
            return
        }

        if let topViewController = navigationController.topViewController {
            trackScrollViewIfExists(controller: topViewController)
        }
        controllers.forEach { runCompletion(for: $0) }
    }

    public func setFloatingPanelIsSwipable(isEnabled: Bool, in module: Presentable) {
        if
            let parent = navigationController.parent,
            let floatingPanelController = parent as? FloatingPanelController
        {
            floatingPanelController.panGestureRecognizer.isEnabled = isEnabled
        }
    }

    private func trackScrollViewIfExists(controller: UIViewController) {
        guard
            let floatingPanelContentViewController = controller as? BaseFloatingPanelContentViewController,
            let scrollView = floatingPanelContentViewController.scrollView,
            let floatingPanelController = navigationController.parent as? FloatingPanelController,
            floatingPanelController.panGestureRecognizer.isEnabled
        else {
            return
        }

        floatingPanelController.track(scrollView: scrollView)
    }

    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else {
            return
        }

        completion()
        completions.removeValue(forKey: controller)
    }

    private func makeFloatingPanelController(
        layout: FloatingPanelLayout,
        isSwipable: Bool,
        cornerRadius: CGFloat
    ) -> FloatingPanelController {
        let controller = FloatingPanelController(delegate: self)
        controller.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        controller.contentInsetAdjustmentBehavior = .never
        controller.isRemovalInteractionEnabled = true
        controller.layout = layout
        controller.panGestureRecognizer.isEnabled = isSwipable
        controller.surfaceView.grabberHandle.isHidden = true

        let appearance = SurfaceAppearance()
        appearance.cornerRadius = cornerRadius
        controller.surfaceView.appearance = appearance

        return controller
    }
}

// MARK: - UINavigationControllerDelegate

extension Router: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard
            let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController)
        else {
            return
        }

        trackScrollViewIfExists(controller: viewController)
        runCompletion(for: poppedViewController)
    }
}

// MARK: - Presentable

extension Router: Presentable {
    public func toPresent() -> UIViewController {
        navigationController
    }
}

// MARK: - FloatingPanelControllerDelegate

extension Router: FloatingPanelControllerDelegate {
    public func floatingPanelDidRemove(_ fpc: FloatingPanelController) {
        runCompletion(for: fpc)
    }

    public func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        let heightForFull = fpc.surfaceLocation(for: .full)

        if fpc.surfaceLocation.y < heightForFull.y {
            fpc.surfaceLocation = heightForFull
        }
    }

    public func floatingPanel(
        _ fpc: FloatingPanelController,
        shouldRemoveAt location: CGPoint,
        with velocity: CGVector
    ) -> Bool {
        velocity.dy >= 3.5
    }
}
