/*
* Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
* Proprietary and confidential.
*/

import Foundation

class CalendarObservable<ObservedType> {

  public typealias Observer = (CalendarObservable<ObservedType>, ObservedType) -> Void
  private var observers: [Observer]
  public var value: ObservedType {
    didSet {
      notifyObservers(value)
    }
  }

  public init(_ value: ObservedType) {
    self.value = value
    observers = []
  }

  public func bind(observer: @escaping Observer) {
    self.observers.append(observer)
  }

  private func notifyObservers(_ value: ObservedType) {
    self.observers.forEach { [unowned self](observer) in
      observer(self, value)
    }
  }

  func removeAllObservers() {
    self.observers.removeAll()
  }

}
