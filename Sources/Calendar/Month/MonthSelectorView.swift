/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - MonthSelectorViewDelegate

/// `MonthSelectorView` delegate protocol notify when an user event occured
protocol MonthSelectorViewDelegate: class {
  func monthSelectorView(_ monthSelectorView: MonthSelectorView, didTapOnNextMonthButton button: UIButton)
  func monthSelectorView(_ monthSelectorView: MonthSelectorView, didTapOnPreviousMonthButton button: UIButton)
  func monthSelectorView(_ monthSelectorView: MonthSelectorView, didScrollToMonthIndexPath indexPath: IndexPath)
}

// MARK: - MonthSelectorView

/// Display an view which allow user to select a month
class MonthSelectorView: UIView {

  // MARK: Public properties

  /// `MonthSelectorView` delegate, notify all user interactions
  weak var delegate: MonthSelectorViewDelegate?

  // MARK: Private properties

  /// MonthSelectorView viewModel, provide all information, and perform user action
  private let viewModel: MonthListViewModel

  private let theme: CalendarViewControllerTheme

  /// If the value is true, the collectionView should be reload at the end of
  /// scrolling (scrollViewDidEndScrollingAnimation or scrollViewDidEndDecelerating)
  private var shouldReloadWhenScrollStop  = false

  /// Store the user selection and notify the delegate and the viewModel
  private var selectedIndexPath = IndexPath(item: 0, section: 0) {
    didSet {
      self.delegate?.monthSelectorView(self, didScrollToMonthIndexPath: self.selectedIndexPath)
      self.viewModel.userWantToDisplayMonthDay(indexPath: selectedIndexPath)
    }
  }

  /// Store if the scroll is currently in an animation
  /// this bool is set to true before calling `scrollToItemAtAnimating`
  /// and set to false in `scrollViewWillBeginDragging` or in `scrollViewDidEndScrollingAnimation`
  private var isAnimated: Bool = false

  /// MARK: UIView

  /// Right button spinner, display during lazy loading
  private let spinner: UIActivityIndicatorView = {
    let dest = UIActivityIndicatorView(style: .gray)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Main collectionView display months
  private let collectionView: UICollectionView = {
    let layout = MonthSelectorViewCollectionViewLayout()
    let dest = UICollectionView(frame: .zero, collectionViewLayout: layout)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Left button, scroll to the previous month
  private let leftButton: UIButton = {
    let dest = UIButton(type: .custom)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Right button, scroll to the next month
  private let rightButton: UIButton = {
    let dest = UIButton(type: .custom)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Setup the layout
  private func setupLayout() {
    var constraints = [NSLayoutConstraint]()

    constraints.append(self.leftButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CalendarMetrics.grid(4)))
    constraints.append(self.leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor))

//    constraints.append(self.leftButton.heightAnchor.constraint(lessThanOrEqualToConstant: CalendarMetrics.grid(11)))
//    constraints.append(self.leftButton.widthAnchor.constraint(lessThanOrEqualToConstant: CalendarMetrics.grid(11)))

    constraints.append(self.rightButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -CalendarMetrics.grid(4)))
    constraints.append(self.rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor))

//    constraints.append(self.rightButton.heightAnchor.constraint(lessThanOrEqualToConstant: CalendarMetrics.grid(11)))
//    constraints.append(self.rightButton.widthAnchor.constraint(lessThanOrEqualToConstant: CalendarMetrics.grid(11)))

//    constraints.append(self.rightButton.widthAnchor.constraint(equalTo: self.leftButton.widthAnchor, multiplier: 1.0))
//    constraints.append(self.rightButton.heightAnchor.constraint(equalTo: self.leftButton.heightAnchor, multiplier: 1.0))

    constraints.append(self.collectionView.topAnchor.constraint(equalTo: self.topAnchor))
    constraints.append(self.collectionView.leftAnchor.constraint(equalTo: self.leftButton.rightAnchor, constant: CalendarMetrics.grid(4)))
    constraints.append(self.collectionView.rightAnchor.constraint(equalTo: self.rightButton.leftAnchor, constant: -CalendarMetrics.grid(4)))
    constraints.append(self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor))

    constraints.append(self.rightButton.centerXAnchor.constraint(equalTo: self.spinner.centerXAnchor))
    constraints.append(self.rightButton.centerYAnchor.constraint(equalTo: self.spinner.centerYAnchor))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup the collectionView, set the dataSource, register cell, set the dataSource
  private func setupCollectionView() {
    self.collectionView.contentInsetAdjustmentBehavior = .never
    self.collectionView.isPagingEnabled = true
    self.collectionView.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.reuseCellIdentifier)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.backgroundColor = UIColor.clear
    self.collectionView.showsVerticalScrollIndicator = false
    self.collectionView.showsHorizontalScrollIndicator = false
  }

  /// Handle method when the user tap on the left or right button
  ///
  /// - Parameter button: button user pressed
  @objc private func handleButtonAction(button: UIButton) {
    guard self.shouldReloadWhenScrollStop == false else { return }
    if button == self.leftButton {
      self.delegate?.monthSelectorView(self, didTapOnPreviousMonthButton: button)
        self.viewModel.userWantToDisplayPreviousMonth()
    } else if button == self.rightButton {
      self.delegate?.monthSelectorView(self, didTapOnNextMonthButton: button)
      self.viewModel.userWantToDisplayNextMont()
    }
  }

  /// Setup left and right buttons target
  private func setupButtons() {
    self.leftButton.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
    self.rightButton.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
  }

  /// Setup the view hierarchy
  private func setupView() {
    self.addSubview(self.leftButton)
    self.addSubview(self.rightButton)
    self.addSubview(self.spinner)
    self.addSubview(self.collectionView)
  }

  /// Update a button with the current state
  ///
  /// - Parameters:
  ///   - button: button to update
  ///   - displayState: state to apply
  private func update(button: UIButton, displayState: MonthListViewModel.ArrowButtonDisplayState) {

    switch displayState {
    case .enable:
      if button == self.rightButton {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
      }
      button.isHidden = false
      button.isEnabled = true
    case .disabled:
      if button == self.rightButton {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
      }
      button.isHidden = false
      button.isEnabled = false
    case .loading:
      button.isHidden = true
      self.spinner.startAnimating()
      self.spinner.isHidden = false
    }
  }

  /// Setup ViewModel and subscribe to observable properties
  private func setupViewModel() {
    self.viewModel.leftButtonDisplayState.bind { [weak self] _, displayState in
      guard let `self` = self else { return }
      DispatchQueue.main.async { self.update(button: self.leftButton, displayState: displayState) }
    }

    self.viewModel.rightButtonDisplayState.bind { [weak self] _, displayState in
      guard let `self` = self else { return }
      DispatchQueue.main.async { self.update(button: self.rightButton, displayState: displayState) }
    }

    self.viewModel.selectedIndexPath.bind { [weak self] _, indexPath in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        guard self.shouldReloadWhenScrollStop == false else {
          return
        }
        self.isAnimated = true
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      }
    }

    self.update(button: self.leftButton, displayState: self.viewModel.leftButtonDisplayState.value)
    self.update(button: self.rightButton, displayState: self.viewModel.rightButtonDisplayState.value)
    self.viewModel.delegate = self
    self.shouldReloadMonth()
  }

  /// Setup button styles in normal and disable mode
  private func setupStyle() {

    self.leftButton.setImage(self.theme.monthSelectorView.leftButtonEnabledImage, for: .normal)
    self.leftButton.setImage(self.theme.monthSelectorView.leftButtonDisabledImage, for: .disabled)
    
    self.rightButton.setImage(self.theme.monthSelectorView.rightButtoEnablednImage, for: .normal)
    self.rightButton.setImage(self.theme.monthSelectorView.rightButtonDisabledImage, for: .disabled)
  }

  /// Setup:
  /// - View hierarchy
  /// - Layout
  /// - the CollectionView
  /// - the viewModel
  /// - buttons
  private func setup() {
    self.setupStyle()
    self.setupView()
    self.setupLayout()
    self.setupCollectionView()
    self.setupViewModel()
    self.setupButtons()
  }

  // MARK: Public properties

  // MARK: Init

  init(viewModel: MonthListViewModel, theme: CalendarViewControllerTheme) {
    self.viewModel = viewModel
    self.theme = theme
    super.init(frame: .zero)
    self.setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UIScrollViewDelegate

extension MonthSelectorView: UIScrollViewDelegate {

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let center = self.convert(self.collectionView.center, to: self.collectionView)
    if let index = collectionView.indexPathForItem(at: center) {
      self.selectedIndexPath = index
    }

    if shouldReloadWhenScrollStop == true {
      let oldOffset = self.collectionView.contentOffset
      self.collectionView.reloadData()
      self.collectionView.setContentOffset(oldOffset, animated: false)
      self.shouldReloadWhenScrollStop = false
    }
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.isAnimated = false
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.isAnimated = false
    if shouldReloadWhenScrollStop == true {
      let oldOffset = self.collectionView.contentOffset
      self.collectionView.reloadData()
      self.collectionView.setContentOffset(oldOffset, animated: false)
      self.shouldReloadWhenScrollStop = false
    }
  }
}

// MARK: - UICollectionViewDataSource

extension MonthSelectorView: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.viewModel.monthsCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.reuseCellIdentifier, for: indexPath)
    guard let castedCell = cell as? MonthCell, let monthModel = self.viewModel[indexPath] else { return cell }
    castedCell.configure(model: monthModel, theme: self.theme)
    return castedCell
  }
}

// MARK: - UICollectionViewDelegate

extension MonthSelectorView: UICollectionViewDelegate {}

// MARK: - MonthListViewModelDelegate

extension MonthSelectorView: MonthListViewModelDelegate {
  func shouldReloadMonth() {

    guard
        self.collectionView.isDragging == true ||
        self.collectionView.isDecelerating == true ||
        self.isAnimated == true || self.collectionView.isTracking == true else  {
      let oldValue = self.collectionView.contentOffset
      self.collectionView.reloadData()
      self.collectionView.setContentOffset(oldValue, animated: false)
          self.shouldReloadWhenScrollStop = false
      return
    }
    self.shouldReloadWhenScrollStop = true
  }
}
