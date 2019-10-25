/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - CalendarViewControllerDelegate

/// `CalendarViewController` Delegate, conform to this protocol to
/// be notify of `CalendarViewController` user actions
public typealias CalendarViewControllerDelegate =
  CalendarViewControllerOptionalDelegate &
  CalendarViewControllerRequiredDelegate

// MARK: CalendarViewControllerRequiredDelegate

public protocol CalendarViewControllerRequiredDelegate: class {

  /// Called when the user tap on the cancel button
  func calendar(_ calendar: CalendarViewController, didTapOnCancelButton button: UIButton)

  /// Called when the user tap on the OK button with a selectedDate
  func calendar(_ calendar: CalendarViewController, didTapOnOkButton selectedDate: Date, andCode code: String)
}

public protocol CalendarViewControllerOptionalDelegate: class {

  // MARK: Optional

  /// Called when the user tap on slot
  func calendar(_ calendar: CalendarViewController, didSelectDateAtIndexPath indexPath: IndexPath)

  /// Called when the `CalendarViewController` is presented
  func calendar(_ calendar: CalendarViewController, calendarDidAppearOnViewController: UIViewController?)

  /// Called when the user tap on the next dispo button (when there is no slot for the select day)
  func calendar(_ calendar: CalendarViewController, didTapOnNextDispoButton button: UIButton)

  /// Called when the user tap on the previous dispo button (when there is no slot for the select day)
  func calendar(_ calendar: CalendarViewController, didTapOnPreviousDispoButton button: UIButton)

  /// Called when the user change current month by scrolling
  func calendar(_ calendar: CalendarViewController, didScrollToMonthIndexPath indexPath: IndexPath)

  /// Called when the user select a day by scrolling or by tapping on it
  func calendar(_ calendar: CalendarViewController, didSelectDay indexPath: IndexPath)

  /// Called when the user tap on the next month button
  func calendar(_ calendar: CalendarViewController, didTapOnNextMonthButton button: UIButton)

  /// Called when the user tap on the previous month button
  func calendar(_ calendar: CalendarViewController, didTapOnPreviousMonthButton button: UIButton)

  /// Called when the user change the display period (morning / afternoon)
  func calendar(_ calendar: CalendarViewController, didSelectPeriod period: SlotHeaderCellDelegatePeriod, onSender: UIView)
}


// MARK: - Optional Delegate extension

extension CalendarViewControllerOptionalDelegate {

  func calendar(_ calendar: CalendarViewController, didTapOnNextDispoButton button: UIButton) {}
  func calendar(_ calendar: CalendarViewController, didTapOnPreviousDispoButton button: UIButton) {}

  func calendar(_ calendar: CalendarViewController, didScrollToMonthIndexPath indexPath: IndexPath) {}

  func calendar(_ calendar: CalendarViewController, didTapOnNextMonthButton button: UIButton) {}

  func calendar(_ calendar: CalendarViewController, didTapOnPreviousMonthButton button: UIButton) {}

  func calendar(_ calendar: CalendarViewController, calendarDidAppearOnViewController: UIViewController?) {}

  func calendar(_ calendar: CalendarViewController, didSelectDay indexPath: IndexPath) {}

  func calendar(_ calendar: CalendarViewController, didSelectPeriod period: SlotHeaderCellDelegatePeriod, onSender: UIView) {}

  func calendar(_ calendar: CalendarViewController, didSelectDateAtIndexPath indexPath: IndexPath) {}
}
