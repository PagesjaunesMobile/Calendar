/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

extension CalendarViewController {

  // MARK: - Configuration

  public struct Configuration {

    // MARK: - CellSize

    public enum CellSize {

      // Display Cell in normal size
      case normal

      // Display Cell in big size
      case big

      /// Return if the current state is a bigSize or not
      var isBigCell: Bool {
        switch self {
        case .normal:
          return false
        case .big:
          return true
        }
      }
    }


    /// Theme of the `CalendarViewController`
    let theme: CalendarViewControllerTheme

    /// Provide Days, slots and fetch method to `CalendarViewController`
    let dataProvider: CalendarDataProvider

    /// Describe the period formating for slots (moring / afternon)
    let periodFormater: CalendarPeriodFormater

    /// locale to use on the month / day and hour display
    let locale: Locale

    /// Describe if the header should use Blur Effect View
    let shouldUseEffectView: Bool

    /// Define the cell size mode (normal or big)
    let cellSize: CellSize

    /// Set the `CalendarViewControllerDelegate` to the `CalendarViewController`, the delegate can be set latter
    let calendarViewControllerDelegate: CalendarViewControllerDelegate?
    
    public init(dataProvider: CalendarDataProvider,
                theme: CalendarViewControllerTheme = CalendarViewControllerTheme.default,
                periodFormater: CalendarPeriodFormater = DefaultCalendarPeriodFormater(),
                locale: Locale = Locale.current,
                shouldUseEffectView: Bool = false,
                cellSize: CellSize = .normal,
                calendarViewControllerDelegate: CalendarViewControllerDelegate? = nil) {
      self.dataProvider = dataProvider
      self.periodFormater = periodFormater
      self.locale = locale
      self.shouldUseEffectView = shouldUseEffectView
      self.calendarViewControllerDelegate = calendarViewControllerDelegate
      self.theme = theme
      self.cellSize = cellSize
    }
  }
  
}
