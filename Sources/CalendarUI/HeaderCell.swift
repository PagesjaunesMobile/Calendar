/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - HeaderCell

/// Display `DaySelectorView`, and `MonthSelectorView` inside an `UIVisualEffectView`
/// or a simple `UIView` according to the parameter `shouldUseEffectView`
/// This view is designed to be used as Header in a UICollectionView
class HeaderCell: UICollectionReusableView {

  // MARK: Public properties

  // MARK: Static Properties

  /// Reusue cell indetifier should be use in collectionView register method.
  static let reusueCellIdentifier = String(describing: HeaderCell.self)

  /// Constant use in `CalendarViewLayout`
  static let hearderheight: CGFloat = CalendarMetrics.grid(53)
  static let minHeaderSize: CGFloat = CalendarMetrics.grid(40)

  // MARK: Private properties

  // MARK: Configuration

  /// Store the value set in the configure method, and define
  /// if the `EffectView` with blur effect should be used or if a standard
  /// UIView should be used instead
  private var shouldUseEffectView: Bool = true

  // MARK: UIView

  /// Simple UIView used instead of the EffectView if the value of `shouldUseEffectView` is false
  private let simpleContentView: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    dest.backgroundColor = UIColor.white
    return dest
  }()

  /// Blur `UIVisualEffectView` this view will be used as content view if the value of `shouldUseEffectView` is true
  private let effectView: UIVisualEffectView = {
    let dest = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    dest.translatesAutoresizingMaskIntoConstraints = false
//    dest.isOpaque = false
    return dest
  }()

  /// Container of `MonthSelectorView`
  private let firstViewContainer: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// One pixel gray line
  private let firstSeparatorView: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// One pixel gray line
  private let secondSeparatorView: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Container of `MonthSelectorView`
  private let secondViewContainer: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Display a View where the user can select a Day
  private var dayView: DaySelectorView?

  /// Display a View where the user can select a Month
  private var monthView: MonthSelectorView?

  /// Store the `CalendarViewController` theme
  private var theme: CalendarViewControllerTheme? {
    didSet {
      if oldValue == nil {
        self.setupTheme()
      }
    }
  }

  // MARK: Private Methods

  /// Setup the view hierarchy according to the value of `shouldUseEffectView`
  private func setupView() {
      if self.shouldUseEffectView == true {
      self.addSubview(self.effectView)
      self.effectView.contentView.addSubview(self.firstSeparatorView)
      self.effectView.contentView.addSubview(self.secondSeparatorView)
      self.effectView.contentView.addSubview(self.firstViewContainer)
      self.effectView.contentView.addSubview(self.secondViewContainer)
    } else {
      self.addSubview(self.simpleContentView)
      self.simpleContentView.addSubview(self.firstSeparatorView)
      self.simpleContentView.addSubview(self.secondSeparatorView)
      self.simpleContentView.addSubview(self.firstViewContainer)
      self.simpleContentView.addSubview(self.secondViewContainer)
    }

  }

  /// Setup the view layout with the view passed in parameter
  ///
  /// - Parameter contentView: container view used to setup the layout
  private func setupLayout(contentView: UIView) {
    var constraints = [NSLayoutConstraint]()

    // EffectView
    constraints.append(contentView.topAnchor.constraint(equalTo: self.topAnchor))
    constraints.append(contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
    constraints.append(contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor))
    constraints.append(contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor))

    // FirstView
    constraints.append(contentView.topAnchor.constraint(equalTo: self.firstViewContainer.topAnchor))
    constraints.append(contentView.leadingAnchor.constraint(equalTo: self.firstViewContainer.leadingAnchor))
    constraints.append(contentView.trailingAnchor.constraint(equalTo: self.firstViewContainer.trailingAnchor))

    // FirstSeparatorView
    constraints.append(self.firstSeparatorView.topAnchor.constraint(equalTo: self.firstViewContainer.bottomAnchor))
    constraints.append(self.firstSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CalendarMetrics.grid(6)))
    constraints.append(self.firstSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CalendarMetrics.grid(6)))
    constraints.append(self.firstSeparatorView.heightAnchor.constraint(equalToConstant: 1.0))

    // SecoundView
    constraints.append(self.secondViewContainer.topAnchor.constraint(equalTo: self.firstSeparatorView.bottomAnchor))
    constraints.append(self.secondViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
    constraints.append(self.secondViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
    constraints.append(self.secondViewContainer.heightAnchor.constraint(equalToConstant: CalendarMetrics.grid(22)))

    // SecounSeparatorView
    constraints.append(self.secondSeparatorView.heightAnchor.constraint(equalToConstant: 1.0))
    constraints.append(self.secondSeparatorView.topAnchor.constraint(equalTo: self.secondViewContainer.bottomAnchor))
    constraints.append(self.secondSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
    constraints.append(self.secondSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
    constraints.append(self.secondSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup the layout according to the value of `shouldUseEffectView`
  private func setupLayout() {
    self.setupLayout(contentView: self.shouldUseEffectView ? self.effectView : self.simpleContentView)
  }

  /// Setup the `MonthSelectorView` if needed
  /// (view hierarchy, layout and configuration)
  ///
  /// - Parameter monthListViewModel: viewModel for `MonthSelectorView`
  private func setupMonthView(monthListViewModel: MonthListViewModel, theme: CalendarViewControllerTheme) {
    guard self.monthView == nil else { return }
    let monthView = MonthSelectorView(viewModel: monthListViewModel, theme: theme)
    monthView.translatesAutoresizingMaskIntoConstraints = false
    self.firstViewContainer.addSubview(monthView)

    var constraints = [NSLayoutConstraint]()

    // MonthView
    constraints.append(monthView.topAnchor.constraint(equalTo: self.firstViewContainer.topAnchor))
    constraints.append(monthView.leadingAnchor.constraint(equalTo: self.firstViewContainer.leadingAnchor))
    constraints.append(monthView.trailingAnchor.constraint(equalTo: self.firstViewContainer.trailingAnchor))
    constraints.append(monthView.bottomAnchor.constraint(equalTo: self.firstViewContainer.bottomAnchor))

    NSLayoutConstraint.activate(constraints)
    self.monthView = monthView
  }

  /// Setup the `DaySelectorView` if needed
  /// (view hierarchy, layout and configuration)
  ///
  /// - Parameter dayListViewModel: viewModel for `DaySelectorView`
  private func setupDayView(dayListViewModel: DayListViewModel, theme: CalendarViewControllerTheme) {
    guard self.dayView == nil else { return }
    let dayView = DaySelectorView(viewModel: dayListViewModel, theme: theme)
    dayView.translatesAutoresizingMaskIntoConstraints = false
    self.secondViewContainer.addSubview(dayView)

    var constraints = [NSLayoutConstraint]()

    // DayView
    constraints.append(dayView.topAnchor.constraint(equalTo: self.secondViewContainer.topAnchor))
    constraints.append(dayView.bottomAnchor.constraint(equalTo: self.secondViewContainer.bottomAnchor))
    constraints.append(dayView.leadingAnchor.constraint(equalTo: self.secondViewContainer.leadingAnchor))
    constraints.append(dayView.trailingAnchor.constraint(equalTo: self.secondViewContainer.trailingAnchor))

    NSLayoutConstraint.activate(constraints)
    self.dayView = dayView
  }

  /// Setup Container view according to the value of `shouldUseEffectView`
  ///
  /// - Parameter shouldUseEffectView: if the value is true,
  //  the `UIVisualEffectView` will be used else the regular view will be used.
  func setupInitialView(shouldUseEffectView: Bool = true) {

    if self.shouldUseEffectView == true {
      guard self.effectView.superview == nil else { return }
    } else {
      guard self.simpleContentView.superview == nil else { return }
    }

    self.setupView()
    self.setupLayout()
    self.setupTheme()
  }

  /// Setup the View theme
  private func setupTheme() {
    guard let theme = self.theme else { return }
    self.secondSeparatorView.backgroundColor = theme.header.separarorColor
    self.firstSeparatorView.backgroundColor = theme.header.separarorColor
  }

  // MARK: Public methods

  /// Configure method designed to be use in from
  /// `viewForSupplementaryElementOfKind At` `UICollectionViewDataSource` method.
  ///
  /// - Parameters:
  ///   - monthListViewModel: `MonthSelectorView` viewModel
  ///   - dayListViewModel: `DaySelectorView` viewModel
  ///   - delegate: delegate conform to `MonthSelectorViewDelegate` and `DaySelectorViewDelegate`
  ///   - shouldUseEffectView: true the `UIVisualEffectView` will be used false
  /// a regular UIView will be used
  func configure(configuration: HeaderCellConfiguration) {
    self.theme = configuration.theme
    self.shouldUseEffectView = configuration.shouldUseEffectView
    self.setupInitialView(shouldUseEffectView: shouldUseEffectView)

    self.setupMonthView(monthListViewModel: configuration.monthListViewModel, theme: configuration.theme)
    self.setupDayView(dayListViewModel: configuration.dayListViewModel, theme: configuration.theme)

    self.monthView?.delegate = configuration.delegate
    self.dayView?.delegate = configuration.delegate
  }

  // MARK: Init

  /// UICollectionReusableView require to override init
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: Typealias

/// Conformance constraint of `MonthSelectorViewDelegate` and `DaySelectorViewDelegate`
typealias HeaderCellDelegate = MonthSelectorViewDelegate & DaySelectorViewDelegate
