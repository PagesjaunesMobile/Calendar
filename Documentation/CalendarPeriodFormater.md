# CalendarPeriodFormater

Protocol, define the morning and the afternoon name.
Required to implement a method wich evaluate
if the date passed in parameter is morning of afternoon.

``` swift
public protocol CalendarPeriodFormater
```

## Conforming Types

[`DefaultCalendarPeriodFormater`](DefaultCalendarPeriodFormater)

## Required Properties

## morningName

Monring name text

``` swift
var morningName: String
```

## afternoonName

AfterNoon name text

``` swift
var afternoonName: String
```

## Required Methods

## isAfternoon(date:)

Evaluate if the date passed in parameter is afternoon or morning

``` swift
func isAfternoon(date: Date) -> Bool
```
