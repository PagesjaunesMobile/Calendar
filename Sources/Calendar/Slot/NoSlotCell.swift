/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

//swiftlint:disable line_length

// MARK: - NoSlotCellDelegate

/// `NoSlotCell` delegate protocol notify when an user event occured
protocol NoSlotCellDelegate: class {
  func noSlotCellView(_ noSlotCellView: NoSlotCell, didTapOnNextDispoButton button: UIButton)
  func noSlotCellView(_ noSlotCellView: NoSlotCell, didTapOnPreviousDispoButton button: UIButton)
}

// MARK: - NoSlotCell

class NoSlotCell: UICollectionViewCell {

  // MARK: Public static properties

  /// Return the cell height, usefull in `CalendarViewLayout`
  static let noSlotCellHeight: CGFloat = CalendarMetrics.grid(100)

  /// Reusue cell indetifier should be use in collectionView register method.
  static let reusueCellIdentifier = String(describing: NoSlotCell.self)

  // MARK: Public properties

  // MARK: Delegate

  weak var delegate: NoSlotCellDelegate?

  // MARK: Private properties

  // MARK: ViewModel

  /// ViewModel of the slotCell, should be var and
  /// optional because of the recycle system of the `UICollectionView`
  private var viewModel: NoSlotCellViewModel?

  private var theme: CalendarViewControllerTheme? {
    didSet {
      if oldValue == nil {
        self.setupTheme()
      }
    }
  }

  // MARK: UIView

  /// Display "Pas de disponibilté pour ce jour." text
  private let titleLabel: UILabel = {
    let dest = UILabel()
    dest.numberOfLines = 0
    dest.textAlignment = .center
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// One pixel gray separator view
  private let separatorView: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Display "Disponibilités les plus proches."
  private let availableDayTitleLabel: UILabel = {
    let dest = UILabel()
    dest.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// `UIStackView` of `AvailableView`
  private let dispoStackView: UIStackView = {
    let dest = UIStackView(frame: .zero)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  // MARK: Private methods

  /// Setup subview layout
  private func setupLayout() {
    var constrains = [NSLayoutConstraint]()

    // titleLabel

    constrains.append(self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: CalendarMetrics.grid(12)))
    constrains.append(self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CalendarMetrics.grid(14)))
    constrains.append(self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -CalendarMetrics.grid(14)))

    // separatorView
    constrains.append(self.separatorView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: CalendarMetrics.grid(6)))
    constrains.append(self.separatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CalendarMetrics.grid(14)))
    constrains.append(self.separatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -CalendarMetrics.grid(14)))
    constrains.append(self.separatorView.heightAnchor.constraint(equalToConstant: 1)) // Explicit designer recomandation

    // availableDayTitleLabel

    constrains.append(self.availableDayTitleLabel.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor, constant: CalendarMetrics.grid(6)))
    constrains.append(self.availableDayTitleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor))

    // dispoStackView

    constrains.append(self.dispoStackView.topAnchor.constraint(equalTo: self.availableDayTitleLabel.bottomAnchor, constant: CalendarMetrics.grid(6)))

    // By setting low priority on leading, and trailing priority,
    // the stackView is able to display one or multiple element centered in the screen without alter the subview frame

    let leadingDispoStackViewConstraint = self.dispoStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CalendarMetrics.grid(10))
    leadingDispoStackViewConstraint.priority = .defaultLow

    let trailingDispoStackViewConstraint = self.dispoStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -CalendarMetrics.grid(10))
    trailingDispoStackViewConstraint.priority = .defaultLow

    constrains.append(self.dispoStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor))

    constrains.append(leadingDispoStackViewConstraint)
    constrains.append(trailingDispoStackViewConstraint)

    NSLayoutConstraint.activate(constrains)
  }

  /// Setup view hierarchy
  private func setupView() {
    self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.separatorView)
    self.contentView.addSubview(self.availableDayTitleLabel)
    self.contentView.addSubview(self.dispoStackView)
  }

  /// Setup View theme
  private func setupTheme() {
    guard let theme = self.theme else { return }
    self.titleLabel.textColor = theme.noSlotCell.titleTextColor
    self.titleLabel.font = theme.noSlotCell.titleFont
    self.separatorView.backgroundColor = theme.noSlotCell.speratorColor
    self.availableDayTitleLabel.textColor = theme.noSlotCell.titleTextColor
    self.availableDayTitleLabel.font = theme.noSlotCell.alviableDayTextFont
  }

  /// Configure the `UIStackView` `dispoStackView`
  private func setupStackView() {
    self.dispoStackView.alignment = .center
    self.dispoStackView.distribution = .equalSpacing
    self.dispoStackView.axis = .horizontal
  }

  /// Setup titleLabel and availableDayTitleLabel text
  private func setupText() {
    self.titleLabel.text = "Pas de disponibilté pour ce jour."
    self.availableDayTitleLabel.text = "Disponibilités les plus proches."
  }

  /// Setup:
  /// - view hierarchy
  /// - view layout
  /// - configure stackView
  /// - set title text
  private func setup() {
    self.setupView()
    self.setupLayout()
    self.setupTheme()
    self.setupStackView()
    self.setupText()
  }

  /// Remove all subviews from the `dispoStackView`
  private func cleanStackView() {
    self.dispoStackView.subviews.forEach {
      self.dispoStackView.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }

  /// Instanciate a new AvailableView with the mode .previous,
  /// set the target and add the view in the `dispoStackView` `UIStackView`
  ///
  /// - Parameter day: day to represent
  private func configureOnePreviousSlot(day: DayViewModel) {
    guard let theme = self.theme else { return }
    let dayView = AvailableView(mode: .previous(date: day), theme: theme)
    dayView.addTarget(self, action: #selector(userDidTapOnPreviousSlot(button:)), for: .touchUpInside)
    self.dispoStackView.addArrangedSubview(dayView)
  }

  /// Instanciate a new AvailableView with the mode .next,
  /// set the target and add the view in the `dispoStackView` `UIStackView`
  ///
  /// - Parameter day: day to represent
  private func configureOneNextSlot(day: DayViewModel) {
    guard let theme = self.theme else { return }
    let dayView = AvailableView(mode: .next(date: day), theme: theme)
    dayView.addTarget(self, action: #selector(userDidTapOnNextSlot), for: .touchUpInside)
    self.dispoStackView.addArrangedSubview(dayView)
  }

  /// Instanciate 2 AvailableView with the mode .previous and .next,
  /// set the target and add views in the `dispoStackView` `UIStackView`
  ///
  /// - Parameter previous: previous day to represent
  /// - Parameter next: next day to represent
  private func configureSlot(previous: DayViewModel, next: DayViewModel) {
    self.configureOnePreviousSlot(day: previous)
    self.configureOneNextSlot(day: next)
  }

  // MARK: Public methods

  // MARK: UICollectionViewCell override

  override func prepareForReuse() {
    super.prepareForReuse()
    self.cleanStackView()
  }

  // MARK: User action handeling method

  /// Handle method when the user tap on the next slot button (AlviableView)
  /// the viewModel will be notify
  ///
  /// - Parameter button: next day button (AlviableView)
  @objc private func userDidTapOnNextSlot(button: UIButton) {
    self.delegate?.noSlotCellView(self, didTapOnNextDispoButton: button)
    guard let viewModel = self.viewModel else { return }
    viewModel.userDidTapOnNextDay()
  }
  /// Handle method when the user tap on the previous slot button (AlviableView)
  /// the viewModel will be notify
  ///
  /// - Parameter button: previous day button (AlviableView)
  @objc private func userDidTapOnPreviousSlot(button: UIButton) {
    self.delegate?.noSlotCellView(self, didTapOnPreviousDispoButton: button)
    guard let viewModel = self.viewModel else { return }
    viewModel.userDidTapOnPreviousDay()
  }

  // MARK: Configure method

  /// Configure the Cell with the correspondingViewModel
  /// designed to be called from the `cellForItem` `UICollectionViewDataSource` method
  ///
  /// - Parameter viewModel: cell viewModel
  func configure(viewModel: NoSlotCellViewModel, theme: CalendarViewControllerTheme) {
    self.viewModel = viewModel
    self.theme = theme

    if let previous = viewModel.previousDay, viewModel.shouldPresentOnePreviousDay {
      self.configureOnePreviousSlot(day: previous)
    }

    if let nexDay = viewModel.nextDay, viewModel.shouldPresentOneNextDay {
      self.configureOneNextSlot(day: nexDay)
    }

    if let previousDay = viewModel.previousDay, let nextDay = viewModel.nextDay, viewModel.shouldPresentPreviousAndNextDay {
      self.configureSlot(previous: previousDay, next: nextDay)
    }
  }

  // MARK: Init

  /// UICollectionViewCell override just call setup
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
