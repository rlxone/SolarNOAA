//
//  Service.swift
//  SharedSolar
//
//  Created by Dmitry on 14.05.21.
//

import Foundation
import SolarNOAA

public struct Service {
    let city: City
    let dayTime: DayTime
    
    public init(city: City, dayTime: DayTime) {
        self.city = city
        self.dayTime = dayTime
    }
    
    public func calculate() -> Result {
        // Get current date
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        
        let year = calendar.component(.year, from: dayTime.date)
        let month = calendar.component(.month, from: dayTime.date)
        let day = calendar.component(.day, from: dayTime.date)
        
        // Get sunrise and sunset in days with zero timezone
        let sunriseDaysTime = Solar.sunrise(
            lat: city.latitude,
            lon: city.longitude,
            year: year,
            month: month,
            day: day,
            timezone: dayTime.timezone,
            dlstime: 0
        )
        let sunsetDaysTime = Solar.sunset(
            lat: city.latitude,
            lon: city.longitude,
            year: year,
            month: month,
            day: day,
            timezone: dayTime.timezone,
            dlstime: 0
        )
        let azimuthDegrees = Solar.azimuth(
            lat: city.latitude,
            lon: city.longitude,
            year: year,
            month: month,
            day: day,
            hours: dayTime.hours,
            minutes: dayTime.minutes,
            seconds: dayTime.seconds,
            timezone: dayTime.timezone,
            dlstime: 0
        )
        let elevationDegrees = Solar.elevation(
            lat: city.latitude,
            lon: city.longitude,
            year: year,
            month: month,
            day: day,
            hours: dayTime.hours,
            minutes: dayTime.minutes,
            seconds: dayTime.seconds,
            timezone: dayTime.timezone,
            dlstime: 0
        )
        let solarNoonDaysTime = Solar.solarnoon(
            lat: city.latitude,
            lon: city.longitude,
            year: year,
            month: month,
            day: day,
            timezone: dayTime.timezone,
            dlstime: 0
        )
        
        // Get date from sunrise and sunset days value
        let multiplier: Double = 24 * 60 * 60
        
        let sunriseDate = Date(timeIntervalSince1970: sunriseDaysTime * multiplier)
        let sunsetDate = Date(timeIntervalSince1970: sunsetDaysTime * multiplier)
        let solarNoonTime = Date(timeIntervalSince1970: solarNoonDaysTime * multiplier)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = TimeZone(identifier:"GMT")
        
        return Result(
            sunrise: timeFormatter.string(from: sunriseDate),
            sunset: timeFormatter.string(from: sunsetDate),
            azimuth: "\(azimuthDegrees)",
            elevation: "\(elevationDegrees)",
            solarNoon: timeFormatter.string(from: solarNoonTime)
        )
    }
}
