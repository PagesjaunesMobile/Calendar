# DefaultCalendarPeriodFormater

Standard implementation of the protocol `CalendarPeriodFormater`

``` swift
public struct DefaultCalendarPeriodFormater: CalendarPeriodFormater
```

## Inheritance

[`CalendarPeriodFormater`](CalendarPeriodFormater)

## Initializers

## init()

``` swift
public init()
```

## Properties

## morningName

Default morning name implementation

``` swift
var morningName: String = "Matin"
```

## afternoonName

Default afternoon name implementation

``` swift
var afternoonName: String = "Après midi"
```

## Methods

## isAfternoon(date:)

``` swift
public func isAfternoon(date: Date) -> Bool
```
