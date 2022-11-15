import UIKit

extension UILabel {
    public func estimatedNumberOfLines(width: CGFloat) -> Int {
        guard let text = text else {
            return 0
        }

        let rect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let labelSize = text.boundingRect(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil
        )
        return Int(
            ceil(CGFloat(labelSize.height) / font.lineHeight)
        )
    }
}
