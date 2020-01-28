# CalendarDataProvider

MARK: - CalendarDataProvider
Protocol to implement in order to provide Date and slot to `CalendarViewController`

``` swift
public protocol CalendarDataProvider
```

## Required Methods

## loadData(completion:)

This method will be used in the initial loading,
it should provide an array of `DayDataProviderModel` with some `SlotDataProviderModel` inside

``` swift
func loadData(completion: @escaping (CalendarDataProviderResult) -> Void)
```

  - Parameter completion: completion closure

## loadNextResult(fromDate:completion:)

This method will be used during lazy loading process,
it should provide an array of `DayDataProviderModel` with some `SlotDataProviderModel` inside

``` swift
func loadNextResult(fromDate date: Date, completion: @escaping (CalendarDataProviderResult) -> Void)
```

  - Parameter date: start point date, returned date should be after this date

<!-- end list -->

  - Parameter completion: completion closure
