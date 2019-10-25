/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - DaySelectorViewDelegate

/// `DaySelectorView` delegate protocol notify when an user event occured
protocol DaySelectorViewDelegate: class {
  func daySelectorView(_ daySelectorView: DaySelectorView, didSelectDay indexPath: IndexPath)
}

// MARK: - DaySelectorView

/// Represent a list of day, and the user can select one
class DaySelectorView: UIView {

  // MARK: Private properties

  /// Store if the scroll is currently in an animation
  /// this bool is set to true before calling `scrollToItemAtAnimating`
  /// and set to false in `scrollViewWillBeginDragging` or in `scrollViewDidEndScrollingAnimation`
  private var isScrollAnimated = false

  /// If the value is true, the collectionView should be reload at the end of
  /// scrolling (scrollViewDidEndScrollingAnimation or scrollViewDidEndDecelerating)
  private var shouldReloadWhenAnimationStop = false

  /// Store the user selection and notify the delegate and the viewModel
  private var selectedIndexPath = IndexPath(item: 0, section: 0) {
    didSet {
      self.viewModel.userSelectNewDay(indexPath: selectedIndexPath)
    }
  }

  // MARK: ViewModel

  /// DaySelectorView viewModel, provide all information, and perform user action
  private let viewModel: DayListViewModel

  // MARK: Theme

  /// Store the `CalendarViewController` theme
  private let theme: CalendarViewControllerTheme

  // MARK: UIView

  /// Represent the user selection
  private let glassView: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Main CollectionView, where days are displayed
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 8

    let dest = UICollectionView(frame: .zero, collectionViewLayout: layout)
    dest.backgroundColor = UIColor.clear
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Spinner add inside the collectionView during lazy loading process
  private let spinner = UIActivityIndicatorView(style: .gray)

  // MARK: Public properties

  /// `DaySelectorView` delegate, notify all user interactions
  weak var delegate: DaySelectorViewDelegate?

  // MARK: Private methods

  /// Setup the collectionView, dataSource, delegate,
  /// configure apparence and register cell
  private func setupCollectionView() {
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.isPagingEnabled = false
    self.collectionView.showsHorizontalScrollIndicator = false
    self.collectionView.showsVerticalScrollIndicator = false
    self.collectionView.register(DaySelectorCell.self, forCellWithReuseIdentifier: DaySelectorCell.reuseIdentifier)
  }

  /// Setup subview layout
  private func setupLayout() {
    var constraints = [NSLayoutConstraint]()

    constraints.append(self.glassView.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor))
    constraints.append(self.glassView.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor))

    constraints.append(self.glassView.widthAnchor.constraint(equalToConstant: CalendarMetrics.grid(18)))
    constraints.append(self.glassView.heightAnchor.constraint(equalToConstant: CalendarMetrics.grid(14)))

    constraints.append(self.collectionView.topAnchor.constraint(equalTo: self.topAnchor))
    constraints.append(self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
    constraints.append(self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor))
    constraints.append(self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor))

    NSLayoutConstraint.activate(constraints)
  }

  /// Return an offset when the select day is centered
  ///
  /// - Parameters:
  ///   - contentOffset: contentOffset to adjust
  /// - Returns: adjusted content offset
  private func getCenteredOffset(from contentOffset: CGPoint) -> CGPoint {

    guard
      let attribute0 = self.collectionView.collectionViewLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0)),
      let attribute1 = self.collectionView.collectionViewLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))
      else { return contentOffset }

    let itemSpace: CGFloat = attribute1.frame.origin.x - attribute0.frame.origin.x

    let precisePage = contentOffset.x / itemSpace
    let page: Int

    if precisePage.truncatingRemainder(dividingBy: 1.0) < 0.5 {
      page = Int(floor(contentOffset.x / itemSpace))
    } else {
      page = Int(ceil(contentOffset.x / itemSpace))
    }

    return CGPoint(x: (CGFloat(page) * itemSpace), y: contentOffset.y)
  }

  /// Setup view hierarchy
  private func setupView() {
    self.addSubview(self.glassView)
    self.addSubview(self.collectionView)
    self.collectionView.addSubview(self.spinner)
    self.spinner.hidesWhenStopped = true
  }

  /// Setup the viewModel delegate and bind observable properties
  private func setupViewModel() {

    self.viewModel.selectedIndexPath.bind { [weak self] _, indexPath in
      guard let `self` = self  else { return }
      DispatchQueue.main.async { self.selectItem(at: indexPath) }
    }

    self.viewModel.delegate = self
  }

  /// Setup View Theme
  private func setupTheme() {
    self.glassView.backgroundColor = self.theme.daySelectorView.glassViewBackgroundColor
    self.glassView.layer.cornerRadius = 7.0
  }

  /// Setup:
  /// - View hierarchy
  /// - Subview layout
  /// - CollectionView configuration
  /// - Setup ViewModel (subscribe to Observable properties and set the delegate)
  /// - Setup view theme
  private func setup() {
    self.setupView()
    self.setupLayout()
    self.setupCollectionView()
    self.setupViewModel()
    self.setupTheme()
  }

  /// Update the selectedIndexPath with the indexPath of the element in the center of the collectionView
  private func updateSelectedIndexPath() {
    let center = self.convert(self.collectionView.center, to: self.collectionView)
    if let index = collectionView.indexPathForItem(at: center) {
      self.selectedIndexPath = index
    }
  }

  /// Select an item at a specific indexPath
  ///
  /// - Parameter indexPath: selectedIndexPath
  private func selectItem(at indexPath: IndexPath) {
    guard indexPath != self.selectedIndexPath else { return }
    self.isScrollAnimated = true
    guard self.shouldReloadWhenAnimationStop == false else { return }
    self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }

  // MARK: Init

  /// `DaySelectorView` init
  ///
  /// - Parameter viewModel: `DaySelectorView` viewModel
  init(viewModel: DayListViewModel, theme: CalendarViewControllerTheme) {
    self.viewModel = viewModel
    self.theme = theme
    super.init(frame: .zero)
    self.setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UICollectionViewDataSource

extension DaySelectorView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.viewModel.daysCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DaySelectorCell.reuseIdentifier, for: indexPath)
    guard let viewModel = self.viewModel[indexPath], let castedCell = cell as? DaySelectorCell else { return cell }
    castedCell.configure(model: viewModel, theme: self.theme)
    return castedCell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DaySelectorView: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    let offset = ((collectionView.frame.size.width / 2.0) - (DaySelectorCell.cellSize.width / 2.0))

    return UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return DaySelectorCell.cellSize
  }
}

// MARK: - UIScrollViewDelegate

extension DaySelectorView: UIScrollViewDelegate {

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    targetContentOffset.pointee = self.getCenteredOffset(from: targetContentOffset.pointee)
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.isScrollAnimated = false
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.isScrollAnimated = false
    if self.shouldReloadWhenAnimationStop == true {
      self.shouldReloadWhenAnimationStop = false
      self.spinner.stopAnimating()
      let oldContentOffset = self.collectionView.contentOffset
      self.collectionView.reloadData()
      self.collectionView.setContentOffset(oldContentOffset, animated: false)
    } else {
      self.updateSelectedIndexPath()
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard self.isScrollAnimated == false else {
      return
    }
    self.updateSelectedIndexPath()
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    if self.shouldReloadWhenAnimationStop == true {
      self.shouldReloadWhenAnimationStop = false
      self.spinner.stopAnimating()
      let offset = self.collectionView.contentOffset
      self.collectionView.reloadData()
      self.collectionView.setContentOffset(offset, animated: false)
    }
    self.delegate?.daySelectorView(self, didSelectDay: self.selectedIndexPath)
  }
}

// MARK: - DayListViewModelDelegate

extension DaySelectorView: DayListViewModelDelegate {

  /// Update the spinnerFrame according to the contentSize of the collectionView
  private func updateSpinnerFrame() {
    let offset = ((collectionView.frame.size.width / 2.0) - (DaySelectorCell.cellSize.width / 2.0))
    let centerY = (self.collectionView.frame.size.height / 2.0) - (spinner.frame.size.height / 2.0)
    let spinnerX = (self.collectionView.contentSize.width - offset) + (DaySelectorCell.cellSize.width / 2.0)
    self.spinner.frame = CGRect(x: spinnerX, y: centerY, width: spinner.frame.size.width, height: spinner.frame.size.height)
  }

  func shouldReloadDays() {

    guard
      self.collectionView.isDragging == true ||
        self.collectionView.isDecelerating  == true ||
        self.collectionView.isTracking == true || self.isScrollAnimated == true
      else {
        self.spinner.stopAnimating()
        let oldContentOffset = self.collectionView.contentOffset
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(oldContentOffset, animated: false)
        self.shouldReloadWhenAnimationStop = false
        return
    }

    self.shouldReloadWhenAnimationStop = true
    self.updateSpinnerFrame()
    self.spinner.startAnimating()
  }
}

// MARK: - UICollectionViewDelegate

extension DaySelectorView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.selectItem(at: indexPath)
    self.delegate?.daySelectorView(self, didSelectDay: indexPath)
  }
}
