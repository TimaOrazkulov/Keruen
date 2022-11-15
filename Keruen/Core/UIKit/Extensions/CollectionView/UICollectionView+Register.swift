import UIKit

extension UICollectionView {
    public func register(cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: "\(cellClass)")
    }

    public func register(viewClass: AnyClass, forSupplementaryViewOfKind kind: String) {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: "\(viewClass)")
    }
}
