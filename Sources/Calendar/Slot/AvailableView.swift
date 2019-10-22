/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - Mode

extension AvailableView {

  /// `AvailableView` mode, describe if the view should display
  /// previous or next day, and provide display information (text and image)
  ///
  /// - previous: the day / slot to display is before the current day
  /// - next: the day / slot to display is after the current day
  enum Mode {

    // MARK: Case

    case previous(date: DayViewModel)
    case next(date: DayViewModel)

    // MARK: Computed public properties

    /// Return a left or a right arrow image
    func imageWith(style: CalendarStyle) -> UIImage {
      switch self {
      case .next:
        return style.alviableView.alviableRightButtonImage
      case .previous:
        return style.alviableView.alviableLeftButtonImage
      }
    }

    /// Text representation of the day in the week (Jeu.)
    var dayOfWeeekText: String {
      switch self {
      case .previous(date: let previous):
        return previous.dayOfTheWeek
      case .next(date: let next):
        return next.dayOfTheWeek
      }
    }

    /// Text representation of the day number in the month (28)
    var dayNumberText: String {
      switch self {
      case .previous(date: let previous):
        return previous.dayNumber
      case .next(date: let next):
        return next.dayNumber
      }
    }

    /// Text represetation of the slot hour (12h00)
    var hourText: String? {
      switch self {
      case .next(date: let nextDay):
        return nextDay.firstSlot?.displayText
      case .previous(date: let previousDay):
        return previousDay.firstSlot?.displayText
      }
    }

  }
}

// MARK: - AvailableView

/// This view is display when the user select a day without anyslots,
/// if there is some slots in some days before or after this day,
/// thoses days are display by this view
class AvailableView: UIButton {

  private let style: CalendarStyle

  // MARK: Public Properties

  // MARK: UIButton override

  /// The background change if the view is highlighted
  override var isHighlighted: Bool {
    didSet {
      if self.isHighlighted == true {
        self.backgroundColor = self.style.alviableView.alviableHighlightBackgroundColor
      } else {
        self.backgroundColor = self.style.alviableView.alviableNormalBackgroundColor
      }
    }
  }

  // MARK: Private properties

  // MARK: Model

  /// Describe the display mode of the view,
  /// the day to represent if before or after the current day
  private let mode: Mode

  // MARK: UIView

  /// Display the day name in the week (Jeu.)
  private let dayOfWeekLabel: UILabel = {
    let dest = UILabel()
    dest.textAlignment = NSTextAlignment.center
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Display the day number in the month (28)
  private let numberOfMonthLabel: UILabel = {
    let dest = UILabel()
    dest.textAlignment = NSTextAlignment.center
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Display the next alviable slot hour exemple (12h00)
  private let slotHourLabel: UILabel = {
    let dest = UILabel()
    dest.textAlignment = NSTextAlignment.center
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// If the day is before the current day the arrow will be left otherwise right
  private let arrowImageView: UIImageView = {
    let dest = UIImageView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  // MARK: Private methods

  /// Setup subviews layout when the mode = .next
  private func setupLayoutNextMode() {

    var constraints = [NSLayoutConstraint]()

    constraints.append(self.dayOfWeekLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CalendarMetrics.grid(4)))
    constraints.append(self.dayOfWeekLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CalendarMetrics.grid(4)))
    constraints.append(self.dayOfWeekLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CalendarMetrics.grid(8)))

    constraints.append(self.numberOfMonthLabel.topAnchor.constraint(equalTo: self.dayOfWeekLabel.bottomAnchor, constant: CalendarMetrics.grid(1)))
    constraints.append(self.numberOfMonthLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CalendarMetrics.grid(4)))
    constraints.append(self.numberOfMonthLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CalendarMetrics.grid(8)))

    constraints.append(self.arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CalendarMetrics.grid(2)))
    constraints.append(self.arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor))
    constraints.append(self.slotHourLabel.topAnchor.constraint(equalTo: self.numberOfMonthLabel.bottomAnchor, constant: CalendarMetrics.grid(1)))
    constraints.append(self.slotHourLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CalendarMetrics.grid(2)))
    constraints.append(self.slotHourLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CalendarMetrics.grid(8)))

    constraints.append(self.slotHourLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -CalendarMetrics.grid(4)))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup subviews layout when the mode = .previous
  private func setupLayoutPreviousMode() {
    var constraints = [NSLayoutConstraint]()

    constraints.append(self.dayOfWeekLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CalendarMetrics.grid(4)))
    constraints.append(self.dayOfWeekLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CalendarMetrics.grid(4)))
    constraints.append(self.dayOfWeekLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CalendarMetrics.grid(8)))

    constraints.append(self.numberOfMonthLabel.topAnchor.constraint(equalTo: self.dayOfWeekLabel.bottomAnchor, constant: CalendarMetrics.grid(1)))
    constraints.append(self.numberOfMonthLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CalendarMetrics.grid(4)))
    constraints.append(self.numberOfMonthLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CalendarMetrics.grid(8)))

    constraints.append(self.arrowImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CalendarMetrics.grid(2)))
    constraints.append(self.arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor))

    constraints.append(self.slotHourLabel.topAnchor.constraint(equalTo: self.numberOfMonthLabel.bottomAnchor, constant: CalendarMetrics.grid(1)))
    constraints.append(self.slotHourLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CalendarMetrics.grid(4)))
    constraints.append(self.slotHourLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CalendarMetrics.grid(8)))

    constraints.append(self.slotHourLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -CalendarMetrics.grid(4)))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup subview layout according to the mode
  private func setupLayout() {
    switch self.mode {
    case .next:
      self.setupLayoutNextMode()
    case .previous:
      self.setupLayoutPreviousMode()
    }

    var constraints = [NSLayoutConstraint]()

    constraints.append(self.widthAnchor.constraint(equalToConstant: CalendarMetrics.grid(26)))
    constraints.append(self.heightAnchor.constraint(equalToConstant: CalendarMetrics.grid(28)))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup the view style
  private func setupStyle() {
    self.dayOfWeekLabel.font = style.alviableView.alviableDayOfWeekFont
    self.dayOfWeekLabel.textColor = style.alviableView.alviableDayOfWeekColor

    self.numberOfMonthLabel.font = style.alviableView.alviableDayNumberOfMonthFont
    self.numberOfMonthLabel.textColor = style.alviableView.alviableDayNumberOfMonthColor

    self.slotHourLabel.font = style.alviableView.alviableSlotHourLabelFont
    self.slotHourLabel.textColor = style.alviableView.alviableSlotHourLabelTextColor

    self.layer.borderWidth = 1
    self.layer.borderColor = style.alviableView.alviableSlotBorderColor.cgColor
    self.layer.cornerRadius = 3
  }

  /// Setup the view hierarchy
  private func setupView() {
    self.addSubview(self.dayOfWeekLabel)
    self.addSubview(self.numberOfMonthLabel)
    self.addSubview(self.slotHourLabel)
    self.addSubview(self.arrowImageView)
  }

  /// Setup the arrow image and text
  private func setupMode() {
    self.arrowImageView.image = self.mode.imageWith(style: self.style)
    self.dayOfWeekLabel.text = self.mode.dayOfWeeekText
    self.numberOfMonthLabel.text = self.mode.dayNumberText
    self.slotHourLabel.text = self.mode.hourText
  }

  /// Setup:
  /// - view hierarchy
  /// - Style
  /// - subview layout
  /// - setup mode
  private func setup() {
    self.setupView()
    self.setupStyle()
    self.setupLayout()
    self.setupMode()
  }

  // MARK: Init

  /// Init `AvailableView` according to the mode
  ///
  /// - Parameter mode: display mode
  init(mode: Mode, style: CalendarStyle) {
    self.mode = mode
    self.style = style
    super.init(frame: .zero)
    self.setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
