import UIKit

// MARK: - Constants

private enum Constants {
    static let animationDuration: TimeInterval = 0.25
}

// MARK: - ProgressHUD

public enum ProgressHUD {
    private static var contentView: ContentView?

    public static func startAnimating() {
        guard
            let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
            contentView == nil
        else {
            return
        }

        contentView?.removeFromSuperview()
        contentView = makeContentView(with: window.frame.size)
        window.addSubview(contentView!)

        window.endEditing(true)
        UIView.animate(
            withDuration: Constants.animationDuration,
            animations: { self.contentView?.alpha = 1.0 },
            completion: { _ in self.contentView?.startAnimating() }
        )
    }

    public static func stopAnimating() {
        UIView.animate(
            withDuration: Constants.animationDuration,
            animations: { self.contentView?.alpha = 0.0 },
            completion: { _ in
                self.contentView?.removeFromSuperview()
                self.contentView?.stopAnimating()
                self.contentView = nil
            }
        )
    }

    private static func makeContentView(with size: CGSize) -> ContentView {
        let contentView = ContentView(
            frame: CGRect(origin: .zero, size: size)
        )
        contentView.alpha = 0
        return contentView
    }
}

// MARK: - ProgressHUD.ContentView

extension ProgressHUD {
    private final class ContentView: UIView {
        private lazy var dimmingView = UIView()
        private lazy var activityIndicatorView = ActivityIndicatorView(size: .large)

        override init(frame: CGRect) {
            super.init(frame: frame)

            setup()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            nil
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)

            updateColors()
        }

        func startAnimating() {
            activityIndicatorView.startAnimating()
        }

        func stopAnimating() {
            activityIndicatorView.stopAnimating()
        }

        private func updateColors() {
            dimmingView.backgroundColor = .black.withAlphaComponent(0.3)
            activityIndicatorView.color = .white
        }

        private func setup() {
            dimmingView.addSubview(activityIndicatorView)
            addSubview(dimmingView)

            setupConstraints()
            updateColors()
        }

        private func setupConstraints() {
            dimmingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            activityIndicatorView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-32)
            }
        }
    }
}
