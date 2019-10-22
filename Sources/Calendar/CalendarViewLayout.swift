/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - CalendarViewLayoutDelegate

/// CalendarViewLayout Delegate help to configure the layout
protocol CalendarViewLayoutDelegate: class {
  var shouldDisplayNoSlot: Bool { get }
  var shouldUseBigCellSize: Bool { get }
}

// MARK: - CalendarViewLayout

/// CalendarViewLayout handle the header shrink behaviour and the slot placement
class CalendarViewLayout: UICollectionViewLayout {

  // MARK: Private properties

  /// Portion of screen used to shrink the header (height / 3.0)
  private let shrinkableHeightRatio: CGFloat = 3.0

  /// Number of slots disply in one line, the spacing is dynamic
  private let numberOfElementByLine: CGFloat = 3

  /// `UICollectionViewLayoutAttributes` array, computed in the prepare method and return in `layoutAttributesFor...` methods
  private var attributes = [UICollectionViewLayoutAttributes]()

  /// Compute the offset value according to the header in small size
  ///
  /// - Returns: offset corresponding to the header in small size
  private func getSmallHeaderContentOffet() -> CGFloat {

    guard let collectionView = self.collectionView else { return 0 }

    var index: CGFloat = 0
    var size = HeaderCell.hearderheight

    while size >= HeaderCell.minHeaderSize {
      let avancement = index / (collectionView.frame.size.height / self.shrinkableHeightRatio)
      size = HeaderCell.hearderheight - (avancement * HeaderCell.hearderheight)
      index += 1
    }
    return index
  }

  /// Return the header frame according to the contentOffset parameter
  ///
  /// - Parameter contentOffset: current contentOffset
  /// - Returns: header frame, the height and the y positon change according to the content offset
  private func getHeaderFrame(contentOffset: CGPoint) -> CGRect {
    guard
      let frame = self.collectionView?.frame,
      let contentOffset = self.collectionView?.contentOffset
      else { return .zero }

    let avancement = contentOffset.y / (frame.size.height / self.shrinkableHeightRatio)
    let headerSize = HeaderCell.hearderheight - (avancement * HeaderCell.hearderheight)

    guard headerSize >= HeaderCell.minHeaderSize else {
      return CGRect(x: 0, y: contentOffset.y, width: frame.size.width, height: HeaderCell.minHeaderSize)
    }

    return CGRect(x: 0, y: contentOffset.y, width: frame.size.width, height: HeaderCell.hearderheight - (avancement * HeaderCell.hearderheight))
  }

  /// Return the slot header frame (matin / après midi)
  private var cellHeaderFrame: CGRect {
    guard let collectionView = self.collectionView else { return .zero }
    return CGRect(x: 0, y: HeaderCell.hearderheight, width: collectionView.frame.width, height: SlotHeaderCell.slotHeaderCellHeight)
  }

  /// Return the SlotCell size
  private var cellSize: CGSize {

    guard let layoutDelegate = collectionView?.delegate as? CalendarViewLayoutDelegate else {
      return  CalendarSlotCell.cellSize
    }
    return layoutDelegate.shouldUseBigCellSize == true ? CalendarSlotCell.bigCellSize : CalendarSlotCell.cellSize
  }

  /// Return the computed cell spacing
  private var cellSpacing: CGFloat {
    guard let collectionView = self.collectionView else { return 0 }
    let totalElemSizeSpacingIncluded = collectionView.frame.size.width / self.numberOfElementByLine
    return (totalElemSizeSpacingIncluded - self.cellSize.width)
  }

  /// Return the slotCell according to the parameter indexPath
  ///
  /// - Parameter indexPath: slot indexPath
  /// - Returns: frame according to the slot IndexPath
  private func getCellFrame(for indexPath: IndexPath) -> CGRect {

    let (line, posInLine) = indexPath.item.quotientAndRemainder(dividingBy: Int(self.numberOfElementByLine))

    let smallSpacing =  self.cellSpacing / 2.0

    return CGRect(x: self.cellSpacing + (self.cellSize.width + smallSpacing) * CGFloat(posInLine),
                  y: HeaderCell.hearderheight + self.cellHeaderFrame.height + (CGFloat(line) * (self.cellSize.height + CalendarMetrics.grid(4))),
                  width: self.cellSize.width,
                  height: self.cellSize.height)
  }

  var shouldPresentNoSlot: Bool {
    guard let delegate = self.collectionView?.delegate as? CalendarViewLayoutDelegate else { return false }
    return delegate.shouldDisplayNoSlot
  }

  /// Add Scrollable height in order to let the user scroll from small -> big header and reverse if it's required
  ///
  /// - Parameter size: computed contentSize before evaluation
  /// - Returns: computed contentSize after evaluation
  private func addScrolableContentOffsetIfNeeded(size: CGSize) -> CGSize {
    guard let collectionView = self.collectionView else { return size }
    if size.height < collectionView.frame.height + self.getSmallHeaderContentOffet() {
      return CGSize(width: size.width, height: (collectionView.frame.height + self.getSmallHeaderContentOffet()))
    }
    return size
  }

  // MARK: UICollectionViewLayout override

  override func prepare() {

    guard let collectionView = self.collectionView else { return }

    // Clean all attributes before create new
    self.attributes.removeAll()

    // Create section 0 Header attributes (`HeaderView`)
    let headerAttributes = UICollectionViewLayoutAttributes(
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      with: IndexPath(item: 0, section: 0))

    // We get the headerFrame with the currentContentOffset, the header height will change according to the contentOffset
    headerAttributes.frame = self.getHeaderFrame(contentOffset: collectionView.contentOffset)
    // The zindex is equal to 1 because we want the header on top of the cell
    headerAttributes.zIndex = 1
    self.attributes.append(headerAttributes)

    // if there is no slots to display, we will display the noHeader size, so we have to generate attributes for it
    guard self.shouldPresentNoSlot == false else {
      let noSlotAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 1))

      // The y value will be the height of the `HeaderCell` becauce the `NoSlotCell` will be place just after.
      noSlotAttributes.frame = CGRect(x: 0, y: HeaderCell.hearderheight,
                                      width: collectionView.frame.size.width,
                                      height: NoSlotCell.noSlotCellHeight)

      self.attributes.append(noSlotAttributes)
      return
    }

    // Here we will create attribute for each cell
    if collectionView.numberOfSections > 1 {
      let headerCellAttributes = UICollectionViewLayoutAttributes(
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        with: IndexPath(item: 0, section: 1))
      headerCellAttributes.frame = self.cellHeaderFrame
      self.attributes.append(headerCellAttributes)

      for index in 0..<collectionView.numberOfItems(inSection: 1) {
        let indexPath = IndexPath(item: index, section: 1)
        let cellAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        cellAttribute.frame = self.getCellFrame(for: indexPath)
        // the zIndex will be 0 to be under the header
        cellAttribute.zIndex = 0
        self.attributes.append(cellAttribute)
      }
    }
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func invalidateLayout() {
    super.invalidateLayout()
    self.attributes.removeAll()
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributes.filter { $0.frame.intersects(rect) }
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return attributes.first { $0.indexPath == indexPath && $0.representedElementKind != UICollectionView.elementKindSectionHeader }
  }

  override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return self.attributes.first { $0.indexPath.section == indexPath.section && $0.representedElementKind == elementKind }
  }

  override var collectionViewContentSize: CGSize {
    guard let collectionView = self.collectionView else { return .zero }

    guard collectionView.numberOfSections > 1 else {
      let dest = CGSize(width: collectionView.frame.size.width, height: HeaderCell.hearderheight)
      return self.addScrolableContentOffsetIfNeeded(size: dest)
    }

    guard self.shouldPresentNoSlot == false else {
      let dest = CGSize(width: collectionView.frame.size.width, height: HeaderCell.hearderheight + NoSlotCell.noSlotCellHeight)
      return self.addScrolableContentOffsetIfNeeded(size: dest)
    }

    if collectionView.numberOfItems(inSection: 1) == 0 {
      let dest = CGSize(width: collectionView.frame.size.width, height: (HeaderCell.hearderheight) + SlotHeaderCell.slotHeaderCellHeight)
      return self.addScrolableContentOffsetIfNeeded(size: dest)
    }

    let lastIndexPath = IndexPath(item: collectionView.numberOfItems(inSection: 1) - 1, section: 1)

    let lastCellFrame = self.getCellFrame(for: lastIndexPath)

    return self.addScrolableContentOffsetIfNeeded(size: CGSize(width: collectionView.frame.size.width, height: lastCellFrame.maxY + CalendarMetrics.grid(4)))
  }

}
