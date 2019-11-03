/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - MonthCell

/// Designed to work with `MonthSelectorView`, represent a single month
class MonthCell: UICollectionViewCell {

  // MARK: Public properties

  // MARK: static properties

  /// Id which should be use to register the cell in the `UICollectionView`
  static let reuseCellIdentifier: String = String(describing: MonthCell.self)

  // MARK: Private properties

  // MARK: UIView

  /// ContainerView usefull to center the group inside of the contentView
  private let containerView: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Display the month name exemple "Fevrier"
  private let monthTitle: UILabel = {
    let dest = UILabel()
    dest.translatesAutoresizingMaskIntoConstraints = false
    dest.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    dest.lineBreakMode = .byClipping
    dest.numberOfLines = 0
    dest.adjustsFontSizeToFitWidth = true
    dest.minimumScaleFactor = 0.6
    return dest
  }()

  /// Display the year exemple "2019"
  private let yearTitle: UILabel = {
    let dest = UILabel()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  // MARK: Theme

  /// Store the `CalendarViewController` theme
  private var theme: CalendarViewControllerTheme? {
    didSet {
      if oldValue == nil {
        self.setupTheme()
      }
    }
  }

  /// Setup the cell subview layout
  private func setupLayout() {
    var constraints = [NSLayoutConstraint]()

    constraints.append(self.contentView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor))
    constraints.append(self.contentView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor))

    constraints.append(self.containerView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.6))

    constraints.append(self.monthTitle.topAnchor.constraint(equalTo: self.containerView.topAnchor))
    constraints.append(self.monthTitle.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor))
    constraints.append(self.monthTitle.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor))

    constraints.append(self.yearTitle.topAnchor.constraint(equalTo: self.monthTitle.bottomAnchor))
    constraints.append(self.yearTitle.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor))
    constraints.append(self.yearTitle.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor))
    constraints.append(self.yearTitle.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup the view hierarchy
  private func setupView() {
    self.contentView.addSubview(self.containerView)
    self.containerView.addSubview(self.monthTitle)
    self.containerView.addSubview(self.yearTitle)
  }

  /// Setup the cell theme
  private func setupTheme() {
    guard let theme = theme else { return }
    self.monthTitle.textColor = theme.monthCell.monthTitleTextColor
    self.yearTitle.textColor = theme.monthCell.yearTitleTextColor
    self.monthTitle.font = theme.monthCell.monthTitleTextFont
    self.yearTitle.font = theme.monthCell.yearTitleTextFont
  }

  /// Setup:
  /// - view hierarchy
  /// - view layouting
  /// - view theme
  private func setup() {
    self.setupView()
    self.setupLayout()
    self.setupTheme()
  }

  // MARK: Public methods

  /// Configure method, designed to be called
  /// from the `UICollectionViewDataSource` method `cellForitemAt`
  ///
  /// - Parameter model: viewModel to setup
  func configure(model: MonthViewModel, theme: CalendarViewControllerTheme) {
    self.theme = theme
    self.monthTitle.text = model.monthText
    self.yearTitle.text = model.yearText
  }

  // MARK: Init

  /// UICollectionViewCell init override
  /// setup method is called
  ///
  /// - Parameter frame: frame to use
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
