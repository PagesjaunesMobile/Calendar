/*
* Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
* Proprietary and confidential.
*/

import Foundation
import CoreGraphics

/// Handle Calendar Metrics static functions
struct CalendarMetrics {

  /// Return a grid aligned position / size
  static func grid(_ gridSize: CGFloat) -> CGFloat {
    return gridSize * 4
  }
}
