<p align="center">
  <img width="500" height="379" src="https://user-images.githubusercontent.com/8312717/118853830-dae9bf80-b8dc-11eb-8bef-2a25b0235460.png" />
</p>

# SolarNOAA
Calculation of local times of `sunrise`, `solar noon`, `sunset`, `azimuth`, `elevation` based on the calculation procedure by [NOAA](http://www.srrb.noaa.gov/highlights/sunrise/sunrise.html)

## Installation
### CocoaPods
[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate **SolarNOAA** into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
pod 'SolarNOAA', '~> 1.0.0'
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate **SolarNOAA** into your Xcode project using Carthage, specify it in your `Cartfile`:
```ruby
github "rlxone/SolarNOAA" ~> 1.0.0
```

### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding **SolarNOAA** as a dependency is as easy as adding it to the dependencies value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/rlxone/SolarNOAA.git", .upToNextMajor(from: "1.0.0"))
]
```

## Requirements
- **iOS** 9.0 / **macOS** 10.9 / **tvOS** 9.0 / **watchOS** 2.0
- Swift 5

## Usage
```swift
// Chicago coordinates
let latitude = 41.881832
let longitude = -87.623177
                
// Timezone for UTC-5
let timezone = -5
                
// Get current date
let date = Date()
var calendar = Calendar.current
calendar.timeZone = TimeZone(identifier: "UTC")!
                
let year = calendar.component(.year, from: date)
let month = calendar.component(.month, from: date)
let day = calendar.component(.day, from: date)
                
// Get sunrise and sunset in days
let sunriseDaysTime = Solar.sunrise(lat: latitude, lon: longitude, year: year, month: month, day: day, timezone: timezone, dlstime: 0)
let sunsetDaysTime = Solar.sunset(lat: latitude, lon: longitude, year: year, month: month, day: day, timezone: timezone, dlstime: 0)
                
// Get date from sunrise and sunset days value
let sunriseDate = Date(timeIntervalSince1970: sunriseDaysTime * 24 * 60 * 60)
let sunsetDate = Date(timeIntervalSince1970: sunsetDaysTime * 24 * 60 * 60)
                
let timeFormatter = DateFormatter()
timeFormatter.dateFormat = "HH:mm:ss"
timeFormatter.timeZone = TimeZone(identifier: "UTC")
                
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
dateFormatter.timeZone = TimeZone(identifier: "UTC")
                
print("Chicago sunrise for \(dateFormatter.string(from: date)): \(timeFormatter.string(from: sunriseDate))")
print("Chicago sunset for \(dateFormatter.string(from: date)): \(timeFormatter.string(from: sunsetDate))")
```
