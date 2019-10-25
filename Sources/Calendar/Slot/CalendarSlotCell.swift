/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - CalendarSlotCell

/// Display a slot in the `CallendarViewController`
class CalendarSlotCell: UICollectionViewCell {

  // MARK: Static Public properties

  /// Describe the regular cell size usefull in `CalendarViewLayout`
  static let cellSize =  CGSize(width: CalendarMetrics.grid(22), height: CalendarMetrics.grid(10))

  /// Describe the big cell size usefull in `CalendarViewLayout`
  static let bigCellSize =  CGSize(width: CalendarMetrics.grid(30), height: CalendarMetrics.grid(10))

  /// Reusue cell indetifier should be use in collectionView register method.
  static let reusueCellIdentifier = String(describing: CalendarSlotCell.self)

  // MARK: Private properties

  // MARK: ViewModel

  /// Cell ViewModel
  private var model: TimeSlotViewModel?

  // MARK: Theme

 /// Store the `CalendarViewController` theme
  private var theme: CalendarViewControllerTheme?  = nil {
    didSet {
      if oldValue == nil {
        self.setupTheme()
      }
    }
  }

  // MARK: UIView

  /// Display the slot text (15h00)
  private let titleLabel: UILabel = {
    let dest = UILabel(frame: .zero)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  // MARK: Public properties

  // MARK: UICollectionViewCell override

  /// The theme change when the cell is selected
  override var isSelected: Bool {
    didSet {
      self.isSelected == true ? self.enableSelectedTheme() : self.enableDeselectedTheme()
    }
  }

  // MARK: Private methods

  /// Setup subviews layout
  private func setupLayout() {
    var constraints = [NSLayoutConstraint]()

    constraints.append(self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor))
    constraints.append(self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))

    constraints.append(self.titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.contentView.leftAnchor, constant: CalendarMetrics.grid(1)))
    constraints.append(self.titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: -CalendarMetrics.grid(1)))
    constraints.append(self.titleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: CalendarMetrics.grid(1)))
    constraints.append(self.titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -CalendarMetrics.grid(1)))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup the view hierarchy
  private func setupView() {
    self.contentView.addSubview(self.titleLabel)
  }

  /// Turn on the the selected theme for the cell
  private func enableSelectedTheme() {
    guard let theme = self.theme else { return }

    self.contentView.backgroundColor = theme.slotCell.selectedBackgroundColor
    self.titleLabel.textColor = theme.slotCell.selectedTitleColor
  }

  /// Turn on the the deselected theme for the cell
  private func enableDeselectedTheme() {
    guard let theme = self.theme else { return }

    self.contentView.backgroundColor = theme.slotCell.deselectedBackgroundColor
    self.titleLabel.textColor = theme.slotCell.deselectedTitleColor
  }

  /// Setup cell theme
  private func setupTheme() {
    guard let theme = self.theme else { return }
    self.contentView.layer.borderWidth = 1
    self.contentView.layer.cornerRadius = 4.0
    self.contentView.clipsToBounds = true
    self.contentView.layer.borderColor = theme.slotCell.borderColor.cgColor
    self.titleLabel.font = theme.slotCell.titleFont
    self.titleLabel.textColor = theme.slotCell.selectedTitleColor
  }

  /// Setup:
  /// - View hierarchy
  /// - Subview layout
  /// - Theme
  /// - Aactivate deselected theme
  private func setup() {
    self.setupView()
    self.setupLayout()
    self.setupTheme()
    self.enableDeselectedTheme()
  }

  // MARK: Public methods

  // MARK: Configure method

  /// Configure the cell with the according viewModel
  /// designed to be called from `cellForItemAt` method of `UICollectionViewDataSource` method
  ///
  /// - Parameter model: cell viewModel
  func configure(model: TimeSlotViewModel, theme: CalendarViewControllerTheme) {
    self.theme = theme
    self.model = model
    self.titleLabel.text = model.displayText
    self.isSelected = model.isSelected.value
    model.isSelected.bind { [weak self] _, isSelected in
      guard let `self` = self else { return }

      if isSelected == false {
        DispatchQueue.main.async {
          self.enableDeselectedTheme()
        }
      }
    }
  }

  // MARK: UICollectionViewCell override

  /// Remove the current model, and clean the cell
  override func prepareForReuse() {
    super.prepareForReuse()
    self.model?.isSelected.removeAllObservers()
    self.model = nil
    self.titleLabel.text = nil
  }

  // MARK: Init

  /// UICollectionViewCell init override
  /// just call setup method
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
