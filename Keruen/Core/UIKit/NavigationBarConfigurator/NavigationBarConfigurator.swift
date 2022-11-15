import UIKit

// MARK: - NavigationBarConfigurator

public final class NavigationBarConfigurator {
    public init() {}

    public func configure(navigationBar: UINavigationBar, with style: NavigationBarStyle) {
        switch style {
        case let .default(needsToDisplayShadow):
            configureDefaultNavigationBar(navigationBar, needsToDisplayShadow)
        case .transparent:
            configureTranspartNavigationBar(navigationBar)
        }

        // TODO: -
        navigationBar.tintColor = .black
    }

    private func configureDefaultNavigationBar(_ navigationBar: UINavigationBar, _ needsToDisplayShadow: Bool) {
        navigationBar.prefersLargeTitles = true

        // MARK: - navigationBar appearance на версиях ниже iOS 15 работает неправильно

        if #available(iOS 15.0, *) {
            navigationBar.scrollEdgeAppearance = makeDefaultNavigationBarAppearance(
                needsToDisplayShadow: false
            )
            navigationBar.standardAppearance = makeDefaultNavigationBarAppearance(
                needsToDisplayShadow: needsToDisplayShadow
            )
        } else {
            navigationBar.barTintColor = Assets.fillBackgroundPrimary.color
            navigationBar.largeTitleTextAttributes = makeLargeTitleTextAttributes()
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = needsToDisplayShadow ? nil : UIImage()
            navigationBar.titleTextAttributes = makeTitleTextAttributes()
        }
    }

    private func configureTranspartNavigationBar(_ navigationBar: UINavigationBar) {
        if #available(iOS 15.0, *) {
            navigationBar.scrollEdgeAppearance = makeTransparentNavigationBarAppearance()
            navigationBar.standardAppearance = makeTransparentNavigationBarAppearance()
        } else {
            navigationBar.barTintColor = nil
            navigationBar.largeTitleTextAttributes = makeLargeTitleTextAttributes()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.titleTextAttributes = makeTitleTextAttributes()
        }
    }

    private func makeDefaultNavigationBarAppearance(needsToDisplayShadow: Bool) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance(idiom: .phone)
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Assets.fillBackgroundPrimary.color
        appearance.largeTitleTextAttributes = makeLargeTitleTextAttributes()
        appearance.shadowColor = needsToDisplayShadow ? Assets.fillDivider.color : nil
        appearance.titleTextAttributes = makeTitleTextAttributes()
        return appearance
    }

    private func makeTransparentNavigationBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance(idiom: .phone)
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = makeLargeTitleTextAttributes()
        appearance.titleTextAttributes = makeTitleTextAttributes()
        return appearance
    }

    private func makeLargeTitleTextAttributes() -> [NSAttributedString.Key: Any] {
        [.font: Fonts.title0, .foregroundColor: Assets.textPrimary.color]
    }

    private func makeTitleTextAttributes() -> [NSAttributedString.Key: Any] {
        [.font: Fonts.title2, .foregroundColor: Assets.textPrimary.color]
    }
}

extension NavigationBarConfigurator {
    public func configure(navigationBar: UINavigationBar) {
        configure(
            navigationBar: navigationBar,
            with: .default(needsToDisplayShadow: true)
        )
    }
}
