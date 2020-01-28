# CalendarDataProviderResult

loadData / loadNextResult completion parameter

``` swift
public enum CalendarDataProviderResult
```

  - success: Some days have been loaded, the loading process is a success

<!-- end list -->

  - noResult: There is no problem, but there is 0 result

<!-- end list -->

  - error: Some error occured

## Enumeration Cases

## success

``` swift
case success(days: [DayDataProviderModel])
```

## noResult

``` swift
case noResult
```

## error

``` swift
case error
```
