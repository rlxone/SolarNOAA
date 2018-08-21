# Solar 🌞
Calculation of local times of sunrise, solar noon, sunset, azimuth, elevation based on the calculation procedure by NOAA

### azimuth
```swift

/// Calculate solar azimuth (deg from north) for the entered
/// date, time and location. Returns -999999 if darker than twilight
///
/// - Parameters:
///   - lat: latitude (decimal degrees)
///   - lon: longitude (decimal degrees)
///   - year: year
///   - month: month
///   - day: day
///   - hours: hours
///   - minutes: minutes
///   - seconds: seconds
///   - timezone: time zone hours relative to GMT/UTC (hours)
///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
/// - Returns: solar azimuth in degrees from north
/// - Note: longitude is negative for western hemisphere for input cells
/// in the spreadsheet for calls to the functions named
/// sunrise, solarnoon, and sunset. Those functions convert the
/// longitude to positive for the western hemisphere for calls to
/// other functions using the original sign convention
/// from the NOAA javascript code.
static func azimuth(lat: Double, lon: Double,
                    year: Int, month: Int, day: Int,
                    hours: Int, minutes: Int, seconds: Int,
                    timezone: Int, dlstime: Int) -> Double
```
### elevation
```swift
/// Calculate elevation azimuth (deg from north) for the entered
/// date, time and location.
///
/// - Parameters:
///   - lat: latitude (decimal degrees)
///   - lon: longitude (decimal degrees)
///   - year: year
///   - month: month
///   - day: day
///   - hours: hours
///   - minutes: minutes
///   - seconds: seconds
///   - timezone: time zone hours relative to GMT/UTC (hours)
///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
/// - Returns: solar elevation
/// - Note: longitude is negative for western hemisphere for input cells
/// in the spreadsheet for calls to the functions named
/// sunrise, solarnoon, and sunset. Those functions convert the
/// longitude to positive for the western hemisphere for calls to
/// other functions using the original sign convention
/// from the NOAA javascript code.
static func elevation(lat: Double, lon: Double,
                      year: Int, month: Int, day: Int,
                      hours: Int, minutes: Int, seconds: Int,
                      timezone: Int, dlstime: Int) -> Double
```
### sunrise
```swift
/// Calculate time of sunrise  for the entered date and location.
///
/// - Parameters:
///   - lat: latitude (decimal degrees)
///   - lon: longitude (decimal degrees)
///   - year: year
///   - month: month
///   - day: day
///   - timezone: time zone hours relative to GMT/UTC (hours)
///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
/// - Returns: sunrise time in local time (days)
/// - Note: longitude is negative for western hemisphere for input cells
/// in the spreadsheet for calls to the functions named
/// sunrise, solarnoon, and sunset. Those functions convert the
/// longitude to positive for the western hemisphere for calls to
/// other functions using the original sign convention
/// from the NOAA javascript code.
static func sunrise(lat: Double, lon: Double,
                    year: Int, month: Int, day: Int,
                    timezone: Int, dlstime: Int) -> Double
```
### sunset
```swift
/// Calculate time of sunrise and sunset for the entered date
/// and location.
/// For latitudes greater than 72 degrees N and S, calculations are
/// accurate to within 10 minutes. For latitudes less than +/- 72°
/// accuracy is approximately one minute.
///
/// - Parameters:
///   - lat: latitude (decimal degrees)
///   - lon: longitude (decimal degrees)
///   - year: year
///   - month: month
///   - day: day
///   - timezone: time zone hours relative to GMT/UTC (hours)
///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
/// - Returns: sunset time in local time (days)
/// - Note: longitude is negative for western hemisphere for input cells
/// in the spreadsheet for calls to the functions named
/// sunrise, solarnoon, and sunset. Those functions convert the
/// longitude to positive for the western hemisphere for calls to
/// other functions using the original sign convention
/// from the NOAA javascript code.
static func sunset(lat: Double, lon: Double,
                   year: Int, month: Int, day: Int,
                   timezone: Int, dlstime: Int) -> Double
```
### solarnoon
```swift
/// Calculate the Universal Coordinated Time (UTC) of solar
/// noon for the given day at the given location on earth
///
/// - Parameters:
///   - lat: latitude (decimal degrees)
///   - lon: longitude (decimal degrees)
///   - year: year
///   - month: month
///   - day: day
///   - timezone: time zone hours relative to GMT/UTC (hours)
///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
/// - Returns: time of solar noon in local time days
/// - Note: longitude is negative for western hemisphere for input cells
/// in the spreadsheet for calls to the functions named
/// sunrise, solarnoon, and sunset. Those functions convert the
/// longitude to positive for the western hemisphere for calls to
/// other functions using the original sign convention
/// from the NOAA javascript code.
static func solarnoon(lat: Double, lon: Double,
                      year: Int, month: Int, day: Int,
                      timezone: Int, dlstime: Int) -> Double
```
