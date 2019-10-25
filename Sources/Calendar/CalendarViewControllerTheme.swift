/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - CalendarViewControllerTheme

/// Theme for `CalendarViewController`, describe UI Properties (Color / Font) for all graphical component
public struct CalendarViewControllerTheme {

  // MARK: Public properties

  // MARK: Themes

  /// Describe the theme for the `DaySelectorCell`, the view wich display one day data
  public var daySelectorCell: DaySelectorCellTheme

  /// Describe the theme for the `DaySelectorView`, the view wich display Days
  public var daySelectorView: DaySelectorViewTheme

  /// Theme for the ok and the cancel button on top of the `UIViewController`
  public var okCancelButtons: OkCancelTheme

  /// Theme for `SlotCell`, the slot cell wich are display in the main `UICollectionView` on the `CalendarViewController`
  public var slotCell: SlotCellTheme

  /// Theme for the `NoSlotCell`, this cell is is display when there is no slot for the selected day
  public var noSlotCell: NoSlotCellTheme

  /// Theme for the `AlviableView`, this view is display inside the `NoSlotCell`
  /// view to inform the user about the next or the previous alviable slot
  public var alviableView: AlviableViewTheme

  /// Theme for the `MonthSelectorView`, this view is responsible
  /// of display and select th current month
  public var monthSelectorView: MonthSelectorViewTheme

  /// Theme for the Month cell, represent one month in the `MonthSelectorView`
  public var monthCell: MonthCellTheme

  /// Theme for the `HeaderView` container for the `MonthSelectorView` and the `DaySelectorView`
  public var header: HeaderViewTheme

  // MARK: Static Properties

  // MARK: Default theme

  /// Default theme
  public static let `default`: Self = {

    let dest = CalendarViewControllerTheme(daySelectorCell: DaySelectorCellTheme.default,
                                           daySelectorView: DaySelectorViewTheme.default,
                                           okCancelButtons: OkCancelTheme.default,
                                           slotCell: SlotCellTheme.default,
                                           noSlotCell: NoSlotCellTheme.default,
                                           alviableView: AlviableViewTheme.default,
                                           monthSelectorView: MonthSelectorViewTheme.default,
                                           monthCell: MonthCellTheme.default,
                                           header: HeaderViewTheme.default)
    return dest
  }()
}

extension CalendarViewControllerTheme {

  // MARK: - DaySelectorCellTheme

  // MARK: Public properties

  // MARK: Themes

  /// Describe the theme for the `DaySelectorCell`, the view wich display one day data
  public struct DaySelectorCellTheme {
    /// Font for the `DayNumberLabel` represent the day of the month
    public var dayNumberLabelFont: UIFont

    /// Color for the `DayNumberLabel` represent the day of the month
    public var dayNumberLabelColor: UIColor

    /// Font for the `dayTextLabel` represent the day of the week text (exemple Jeu.)
    public var dayTextLabelFont: UIFont

    /// Color for the `dayTextLabel` represent the day of the week text (exemple Jeu.)
    public var dayTextLabelColor: UIColor

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {
      var dest = DaySelectorCellTheme(dayNumberLabelFont: UIFont.systemFont(ofSize: 32),
                                      dayNumberLabelColor: UIColor.black,
                                      dayTextLabelFont: UIFont.systemFont(ofSize: 17),
                                      dayTextLabelColor: UIColor.black)

      dest.dayNumberLabelFont = UIFont.systemFont(ofSize: 32)
      dest.dayNumberLabelColor = UIColor.black
      dest.dayTextLabelFont = UIFont.systemFont(ofSize: 17)
      dest.dayTextLabelColor = UIColor.black
      return dest
    }()

  }

  // MARK: - DaySelectorViewTheme

  /// Describe the theme for the `DaySelectorView`, the view wich display Days
  public struct DaySelectorViewTheme {

    // MARK: Public properties

    // MARK: Themes


    /// Color of the glassView, the view on the center of the `DaySelectorView` wich indicate the selection.
    public var glassViewBackgroundColor: UIColor

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {
      let dest = DaySelectorViewTheme(glassViewBackgroundColor: UIColor.lightGray)
      return dest
    }()

  }

  // MARK: - OkCancelTheme

  /// Theme for the ok and the cancel button on top of the `UIViewController`
  public struct OkCancelTheme {

    // MARK: Public properties

    // MARK: Themes

    /// Color when the button is enable
    public var enabledColor: UIColor

    /// Color when the button is disabled
    public var disabledColor: UIColor

    /// Ok / Cancel button font
    public var buttonFont: UIFont

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {
      let dest = OkCancelTheme(enabledColor: UIColor.blue,
                               disabledColor: UIColor.lightGray,
                               buttonFont: UIFont.boldSystemFont(ofSize: 17))
      return dest
    }()

  }

  // MARK: - SlotCellTheme

  /// Theme for `SlotCell`, the slot cell wich are display in the main `UICollectionView` on the `CalendarViewController`
  public struct SlotCellTheme {

    // MARK: Public properties

    // MARK: Themes

    /// Color of the slot cell background when the slot is selected
    public var selectedBackgroundColor: UIColor

    /// Color of the slot cell title color when the slot is selected
    public var selectedTitleColor: UIColor

    /// Color of the slot cell background when the slot is deselected
    public var deselectedBackgroundColor: UIColor

    /// Color of the slot cell title color when the slot is selected
    public var deselectedTitleColor: UIColor

    /// Slot title font
    public var titleFont: UIFont

    /// `SlotCell` border color
    public var borderColor: UIColor

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {

      let dest = SlotCellTheme(selectedBackgroundColor: UIColor.blue,
                               selectedTitleColor: UIColor.white,
                               deselectedBackgroundColor: UIColor.white,
                               deselectedTitleColor: UIColor.blue,
                               titleFont: UIFont.systemFont(ofSize: 16),
                               borderColor: UIColor.blue)
      return dest
      
    }()


  }

  // MARK: - NoSlotCellTheme

  /// Theme for the `NoSlotCell`, this cell is is display when there is no slot for the selected day
  public struct NoSlotCellTheme {

    // MARK: Public properties

    // MARK: Themes

    /// Title color of the `NoSlotCell` the title on the top of the view
    public var titleTextColor: UIColor

    /// Font of the `NoSlotCell` the title on the top of the view
    public var titleFont: UIFont

    /// Separator view color between the title and the alviable view label
    public var speratorColor: UIColor

    /// Alviable view title text color, this title explain to the user, the remaining slot options
    public var alviableDayTextColor: UIColor

    /// Alviable view font, this title explain to the user, the remaining slot options
    public var alviableDayTextFont: UIFont

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {
      let dest = NoSlotCellTheme(titleTextColor: UIColor.gray,
                                 titleFont: UIFont.systemFont(ofSize: 24),
                                 speratorColor: UIColor.gray,
                                 alviableDayTextColor: UIColor.gray,
                                 alviableDayTextFont: UIFont.systemFont(ofSize: 17))
      return dest
    }()
  }

  // MARK: - AlviableViewTheme

  /// Theme for the `AlviableView`, this view is display inside the `NoSlotCell`
  /// view to inform the user about the next or the previous alviable slot
  public struct AlviableViewTheme {

    // MARK: Public properties

    // MARK: Themes

    /// Button image for the previous alviable slot button
    public var leftButtonImage: UIImage

    /// Button image for the next alviable slot button
    public var rightButtonImage: UIImage

    /// Normal state background color for the `AlviableView`
    public var normalBackgroundColor: UIColor

    /// Highlight state background color for the `AlviableView`
    public var highlightBackgroundColor: UIColor

    /// Font for the `dayOfWeek` label in the `AlviableView` (jeu.)
    public var dayOfWeekFont: UIFont

    /// Color for the `dayOfWeek` label in the `AlviableView` (jeu.)
    public var dayOfWeekColor: UIColor

    /// Font for the `dayNumberOfMonth` label in the `AlviableView` (24)
    public var dayNumberOfMonthFont: UIFont

    /// Color for the `dayNumberOfMonth` label in the `AlviableView` (24)
    public var dayNumberOfMonthColor: UIColor

    /// Font for the `alviableSlotHourLabel` label in the `AlviableView` (13h00)
    public var alviableSlotHourLabelFont: UIFont

    /// Color for the `alviableSlotHourLabel` label in the `AlviableView` (13h00)
    public var alviableSlotHourLabelTextColor: UIColor

    /// `AlviableView` border color
    public var borderColor: UIColor

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {
      let dest = AlviableViewTheme(leftButtonImage: UIImage(),
                                   rightButtonImage: UIImage(),
                                   normalBackgroundColor: UIColor.blue,
                                   highlightBackgroundColor: UIColor.white,
                                   dayOfWeekFont: UIFont.systemFont(ofSize: 17),
                                   dayOfWeekColor: UIColor.blue,
                                   dayNumberOfMonthFont: UIFont.systemFont(ofSize: 32),
                                   dayNumberOfMonthColor: UIColor.blue,
                                   alviableSlotHourLabelFont: UIFont.systemFont(ofSize: 17),
                                   alviableSlotHourLabelTextColor: UIColor.blue,
                                   borderColor: UIColor.blue)
      return dest
    }()

  }

  // MARK: - MonthSelectorViewTheme

  /// Theme for the `MonthSelectorView`, this view is responsible
  /// of display and select th current month
  public struct MonthSelectorViewTheme {

    // MARK: Public properties

    // MARK: Themes

    /// Button for the previous button of the `MonthSelectorView` in the enabled mode
    public var leftButtonEnabledImage: UIImage

    /// Button for the next button of the `MonthSelectorView` in the enabled mode
    public var rightButtoEnablednImage: UIImage

    /// Button for the previous button of the `MonthSelectorView` in the disabled mode
    public var leftButtonDisabledImage: UIImage

    /// Button for the next button of the `MonthSelectorView` in the enabled mode
    public var rightButtonDisabledImage: UIImage

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {
      let dest = MonthSelectorViewTheme(leftButtonEnabledImage: UIImage(),
                                        rightButtoEnablednImage: UIImage(),
                                        leftButtonDisabledImage: UIImage(),
                                        rightButtonDisabledImage: UIImage())
      return dest
    }()

  }

  // MARK: - MonthCellTheme

  /// Theme for the Month cell, represent one month in the `MonthSelectorView`
  public struct MonthCellTheme {

    // MARK: Public properties

    // MARK: Themes

    /// Describe the text color of the month title of the `MonthCell` (Janvier)
    public var monthTitleTextColor: UIColor

    /// Describe the text font of the month title of the `MonthCell` (Janvier)
    public var monthTitleTextFont: UIFont

    /// Describe the text color of the year title of the `MonthCell` (2019)
    public var yearTitleTextColor: UIColor

    /// Describe the text font of the year title of the `MonthCell` (2019)
    public var yearTitleTextFont: UIFont

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {
      let dest = MonthCellTheme(monthTitleTextColor: UIColor.black,
                                monthTitleTextFont: UIFont.systemFont(ofSize: 32),
                                yearTitleTextColor: UIColor.black,
                                yearTitleTextFont: UIFont.systemFont(ofSize: 17))
      return dest
    }()

  }

  // MARK: - HeaderViewTheme

  /// Theme for the `HeaderView` container for the `MonthSelectorView` and the `DaySelectorView`
  public struct HeaderViewTheme {

    // MARK: Public properties

    // MARK: Themes

    /// Describe the color between the `DayViewSelector`, the `MonthSelectorView` and the slots
    public var separarorColor: UIColor

    // MARK: Static Properties

    // MARK: Default theme

    /// Default theme
    public static let `default`: Self = {
      let dest = HeaderViewTheme(separarorColor: UIColor.gray)
      return dest
    }()
  }
}
