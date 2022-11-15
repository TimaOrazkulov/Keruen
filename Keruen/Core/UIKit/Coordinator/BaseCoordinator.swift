import Foundation

open class BaseCoordinator: Coordinator {
    public let router: Router
    public private(set) var childCoordinators: [Coordinator] = []

    public init(router: Router) {
        self.router = router
    }

    open func start() { /* Do nothing */ }

    public func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }

        childCoordinators.append(coordinator)
    }

    public func removeDependency(_ coordinator: Coordinator?) {
        guard
            let coordinator = coordinator,
            !childCoordinators.isEmpty
        else {
            return
        }

        if let coordinator = coordinator as? BaseCoordinator {
            coordinator.childCoordinators
                .filter { $0 !== coordinator }
                .forEach { coordinator.removeDependency($0) }
        }

        childCoordinators.removeAll { $0 === coordinator }
    }

    public func removeAllDependencies() {
        router.dismissModule(animated: false)
        childCoordinators.forEach { removeDependency($0) }
    }
}
