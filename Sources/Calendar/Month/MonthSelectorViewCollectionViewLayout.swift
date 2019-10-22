/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - MonthSelectorViewCollectionViewLayout

/// `UICollectionViewLayout` override, designed to work with `MonthSelectorView`
/// provide a simple paginate collectionView layout wich dosn't complain when it is resized !
class MonthSelectorViewCollectionViewLayout: UICollectionViewLayout {

  // MARK: Private properties

  /// `UICollectionViewLayoutAttributes` array,
  /// filled in prepare method and returned in `layoutAttributesForElements`
  /// and `layoutAttributesForItem` methods
  private var attributes = [UICollectionViewLayoutAttributes]()

  // MARK: Public methods

  // MARK: UICollectionViewLayout override

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override var collectionViewContentSize: CGSize {
    guard let collectionView = self.collectionView else { return .zero }

    return CGSize(
      width: CGFloat(collectionView.frame.size.width) * CGFloat(collectionView.numberOfItems(inSection: 0)),
      height: collectionView.frame.size.height)
  }

  override func invalidateLayout() {
    super.invalidateLayout()
    self.attributes.removeAll()
  }

  override func prepare() {

    guard let collectionView = self.collectionView else { return }
    self.attributes.removeAll()

    for index in 0..<collectionView.numberOfItems(inSection: 0) {
      let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
      attr.frame = CGRect(
        x: CGFloat(index) * collectionView.frame.size.width,
        y: 0,
        width: collectionView.frame.size.width,
        height: collectionView.frame.size.height)

      self.attributes.append(attr)
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let dest =  self.attributes.filter { $0.frame.intersects(rect) }
    return dest
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return self.attributes.first { $0.indexPath == indexPath }
  }

}
