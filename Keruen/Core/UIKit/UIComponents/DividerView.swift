import UIKit

public final class DividerView: UIView {
    override public var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 0.5)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureColors()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        configureColors()
    }

    private func configureColors() {
        backgroundColor = .gray
    }
}
