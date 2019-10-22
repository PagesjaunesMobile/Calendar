/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - DaySelectorCell

/// Designed to work with `DaySelectorView`, represent a day
class DaySelectorCell: UICollectionViewCell {

  // MARK: Static public properties

  /// ReuseIdentifier usefull in registerCell collectionView
  static let reuseIdentifier = String(describing: MonthCell.self)

  /// Usefull in UICollectionViewDelegateFlowLayout
  static let cellSize = CGSize(width: CalendarMetrics.grid(18), height: CalendarMetrics.grid(14))

  // MARK: Private properties

  // MARK: UIView

  /// Display the short name of the day ("Jeu.")
  private let dayTextLabel: UILabel = {
    let dest = UILabel()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Display the number of the day in a month (28)
  private let dayNumberLabel: UILabel = {
    let dest = UILabel()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  private var theme: CalendarViewControllerTheme? {
    didSet {
      self.setupTheme()
    }
  }

  // MARK: Private methods

  /// Setup cell subviews layout
  private func setupLayout() {
    var constraints = [NSLayoutConstraint]()

    // dayTextLabel
    constraints.append(self.dayTextLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor))
    constraints.append(self.dayTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor))
    constraints.append(self.dayTextLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor))

    // dayNumberLabel
    constraints.append(self.dayNumberLabel.topAnchor.constraint(equalTo: self.dayTextLabel.bottomAnchor))
    constraints.append(self.dayNumberLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor))
    constraints.append(self.dayNumberLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor))
    constraints.append(self.dayNumberLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup view hierarchy
  private func setupView() {
    self.contentView.addSubview(self.dayTextLabel)
    self.contentView.addSubview(self.dayNumberLabel)
  }

  /// Setup cell Theme
  private func setupTheme() {
    guard let theme = self.theme else { return }

    self.dayNumberLabel.font = theme.daySelectorCell.dayNumberLabelFont
    self.dayTextLabel.font = theme.daySelectorCell.dayTextLabelFont
    self.dayTextLabel.textAlignment = .center
    self.dayNumberLabel.textAlignment = .center
    self.dayTextLabel.textColor = theme.daySelectorCell.dayTextLabelColor
    self.dayNumberLabel.textColor = theme.daySelectorCell.dayNumberLabelColor
  }

  /// Setup cell theme
  private func setup() {
    self.setupView()
    self.setupLayout()
  }

  // MARK: Public methods

  /// Setup the cell with the given viewModel
  ///
  /// - Parameter model: viewModel to setup
  func configure(model: DayViewModel, theme: CalendarViewControllerTheme) {
    self.dayTextLabel.text = model.dayOfTheWeek
    self.dayNumberLabel.text = model.dayNumber
    self.theme = theme
  }

  // MARK: Init

  /// UICollectionViewCell init override, just call setup method
  ///
  /// - Parameter frame: given frame
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
