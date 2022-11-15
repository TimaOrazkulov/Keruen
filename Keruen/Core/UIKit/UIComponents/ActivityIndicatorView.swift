import UIKit

public final class ActivityIndicatorView: UIView {
    public enum Size {
        case extraSmall
        case small
        case medium
        case large
    }

    override public var intrinsicContentSize: CGSize {
        bounds.size
    }

    override public var bounds: CGRect {
        didSet {
            guard oldValue != bounds, isAnimating else {
                return
            }

            setUpAnimation()
        }
    }

    public var color: UIColor?

    public private(set) var isAnimating = false

    private let thickness: CGFloat

    public convenience init(size: Size, color: UIColor? = nil) {
        switch size {
        case .extraSmall:
            self.init(frame: CGRect(x: 0, y: 0, width: 16, height: 16), thickness: 2, color: color)
        case .small:
            self.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20), thickness: 2, color: color)
        case .medium:
            self.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24), thickness: 2, color: color)
        case .large:
            self.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40), thickness: 3, color: color)
        }
    }

    private init(frame: CGRect, thickness: CGFloat, color: UIColor?) {
        self.thickness = thickness
        self.color = color
        super.init(frame: frame)

        isHidden = true
    }

    public required init?(coder aDecoder: NSCoder) {
        nil
    }

    public func startAnimating() {
        guard !isAnimating else {
            return
        }

        isHidden = false
        isAnimating = true
        layer.speed = 1
        setUpAnimation()
    }

    public func stopAnimating() {
        guard isAnimating else {
            return
        }

        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }

    private func setUpAnimation() {
        layer.sublayers = nil

        let beginTime = 0.5
        let strokeStartDuration = 1.2
        let strokeEndDuration = 0.7

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = Float.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards

        let size = frame.size
        let circle = layerWith(size: size, lineWidth: thickness)
        let frame = CGRect(
            x: (layer.bounds.width - size.width) / 2,
            y: (layer.bounds.height - size.height) / 2,
            width: size.width,
            height: size.height
        )

        circle.frame = frame
        circle.add(groupAnimation, forKey: "animation")
        layer.addSublayer(circle)
    }

    private func layerWith(size: CGSize, lineWidth: CGFloat) -> CALayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()

        path.addArc(
            withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
            radius: size.width / 2,
            startAngle: -(.pi / 2),
            endAngle: .pi + .pi / 2,
            clockwise: true
        )

        layer.backgroundColor = nil
        layer.fillColor = nil
        layer.frame = CGRect(origin: .zero, size: size)
        layer.lineWidth = lineWidth
        layer.path = path.cgPath
        layer.strokeColor = color?.cgColor

        return layer
    }
}
