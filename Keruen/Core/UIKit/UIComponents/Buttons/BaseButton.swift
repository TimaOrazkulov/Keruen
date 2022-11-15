import UIKit

open class BaseButton: UIButton {
    public enum Size {
        case small
        case medium
        case large
        case largeFixed
    }

    override public var intrinsicContentSize: CGSize {
        makeIntristicSize(for: size)
    }

    public var isLoading = false {
        didSet {
            guard oldValue != isLoading else {
                return
            }

            updateLoadingState()
        }
    }

    public var isActiveChevron = false {
        didSet {
            guard oldValue != isActiveChevron else {
                return
            }

            updateChevronState()
        }
    }

    private lazy var activityIndicatorView = makeActivityIndicatorView()

    public let size: Size

    public init(size: Size) {
        self.size = size
        super.init(frame: .zero)

        setup()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        nil
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
        activityIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    private func updateLoadingState() {
        activityIndicatorView.isHidden = !isLoading
        isLoading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        isUserInteractionEnabled = !isLoading
        imageView?.tintColor = isLoading ? .clear : tintColor
        titleLabel?.alpha = isLoading ? 0 : 1
    }

    private func updateChevronState() {
        imageEdgeInsets = makeImageEdgeInsets()
        semanticContentAttribute = isActiveChevron ? .forceRightToLeft : .forceRightToLeft
//        setImage(isActiveChevron ? Assets.chevron8x16.image : nil, for: .normal)
        titleEdgeInsets = makeTitleEdgeInsets()
    }

    private func setup() {
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
        contentEdgeInsets = makeContentEdgeInsets()
        imageEdgeInsets = makeImageEdgeInsets()
        titleEdgeInsets = makeTitleEdgeInsets()
//        titleLabel?.font = size == .small ? Fonts.title6 : Fonts.title3
        setupActivityIndicatorView()
    }

    private func setupActivityIndicatorView() {
        activityIndicatorView.isUserInteractionEnabled = false
        addSubview(activityIndicatorView)
    }

    private func makeIntristicSize(for size: Size) -> CGSize {
        switch size {
        case .small:
            return CGSize(width: super.intrinsicContentSize.width, height: 32)
        case .medium:
            return CGSize(width: super.intrinsicContentSize.width, height: 42)
        case .large:
            return CGSize(width: super.intrinsicContentSize.width, height: 48)
        case .largeFixed:
            return CGSize(width: super.intrinsicContentSize.width, height: 48)
        }
    }

    private func makeActivityIndicatorView() -> ActivityIndicatorView {
        switch size {
        case .small:
            return ActivityIndicatorView(size: .extraSmall, color: .white)
        case .medium:
            return ActivityIndicatorView(size: .small, color: .white)
        case .large:
            return ActivityIndicatorView(size: .medium, color: .white)
        case .largeFixed:
            return ActivityIndicatorView(size: .medium, color: .white)
        }
    }

    private func makeContentEdgeInsets() -> UIEdgeInsets {
        switch size {
        case .small:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case .medium:
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        case .large:
            return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        case .largeFixed:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }

    private func makeImageEdgeInsets() -> UIEdgeInsets {
        switch size {
        case .small:
            return isActiveChevron
                ? UIEdgeInsets(top: 0.5, left: 2, bottom: -0.5, right: -2)
                : UIEdgeInsets(top: 0.5, left: -2, bottom: -0.5, right: 2)
        case .medium:
            return isActiveChevron
                ? UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
                : UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        case .large:
            return isActiveChevron
                ? UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
                : UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        case .largeFixed:
            return isActiveChevron
                ? UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
                : UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        }
    }

    private func makeTitleEdgeInsets() -> UIEdgeInsets {
        switch size {
        case .small:
            return isActiveChevron
                ? UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
                : UIEdgeInsets(top: 0, left: 2, bottom: 0, right: -2)
        case .medium:
            return isActiveChevron
                ? UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
                : UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        case .large:
            return isActiveChevron
                ? UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
                : UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        case .largeFixed:
            return isActiveChevron
                ? UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
                : UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        }
    }
}
