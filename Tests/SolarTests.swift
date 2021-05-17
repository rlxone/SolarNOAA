//
//  SolarTests.swift
//  SolarTests
//
//  Created by Dmitry on 15.05.21.
//

import XCTest
@testable import SolarNOAA

class SolarTests: XCTestCase {
    func testSunrise() {
        // Given
        let expected = testData.map { $0.result.sunrise }
        var results = [String]()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = TimeZone(identifier: "UTC")
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // When
        for data in testData {
            let year = calendar.component(.year, from: data.location.date)
            let month = calendar.component(.month, from: data.location.date)
            let day = calendar.component(.day, from: data.location.date)
            
            let sunriseDaysTime = Solar.sunrise(
                lat: data.location.latitude,
                lon: data.location.longitude,
                year: year,
                month: month,
                day: day,
                timezone: data.location.timezone,
                dlstime: 0
            )
            
            let multiplier: Double = 24 * 60 * 60
            let sunriseDate = Date(timeIntervalSince1970: sunriseDaysTime * multiplier)
            let formattedTime = timeFormatter.string(from: sunriseDate)
            
            results.append(formattedTime)
        }
        
        let zipped = Array(zip(expected, results))
        
        // Then
        zipped.forEach {
            XCTAssertEqual($0.0, $0.1)
        }
    }
    
    func testSunset() {
        // Given
        let expected = testData.map { $0.result.sunset }
        var results = [String]()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = TimeZone(identifier: "UTC")
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // When
        for data in testData {
            let year = calendar.component(.year, from: data.location.date)
            let month = calendar.component(.month, from: data.location.date)
            let day = calendar.component(.day, from: data.location.date)
            
            let sunsetDaysTime = Solar.sunset(
                lat: data.location.latitude,
                lon: data.location.longitude,
                year: year,
                month: month,
                day: day,
                timezone: data.location.timezone,
                dlstime: 0
            )
            
            let multiplier: Double = 24 * 60 * 60
            let sunsetDate = Date(timeIntervalSince1970: sunsetDaysTime * multiplier)
            let formattedTime = timeFormatter.string(from: sunsetDate)
            
            results.append(formattedTime)
        }
        
        let zipped = Array(zip(expected, results))
        
        // Then
        zipped.forEach {
            XCTAssertEqual($0.0, $0.1)
        }
    }
    
    func testSolarNoon() {
        // Given
        let expected = testData.map { $0.result.solarNoon }
        var results = [String]()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = TimeZone(identifier: "UTC")
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // When
        for data in testData {
            let year = calendar.component(.year, from: data.location.date)
            let month = calendar.component(.month, from: data.location.date)
            let day = calendar.component(.day, from: data.location.date)
            
            let solarNoonDaysTime = Solar.solarnoon(
                lat: data.location.latitude,
                lon: data.location.longitude,
                year: year,
                month: month,
                day: day,
                timezone: data.location.timezone,
                dlstime: 0
            )
            
            let multiplier: Double = 24 * 60 * 60
            let solarNoonDate = Date(timeIntervalSince1970: solarNoonDaysTime * multiplier)
            let formattedTime = timeFormatter.string(from: solarNoonDate)
            
            results.append(formattedTime)
        }
        
        let zipped = Array(zip(expected, results))
        
        // Then
        zipped.forEach {
            XCTAssertEqual($0.0, $0.1)
        }
    }
    
    func testAzimuth() {
        // Given
        let expected = testData.map { $0.result.azimuth }
        var results = [Double]()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // When
        for data in testData {
            let year = calendar.component(.year, from: data.location.date)
            let month = calendar.component(.month, from: data.location.date)
            let day = calendar.component(.day, from: data.location.date)
            
            let azimuth = Solar.azimuth(
                lat: data.location.latitude,
                lon: data.location.longitude,
                year: year,
                month: month,
                day: day,
                hours: data.location.hours,
                minutes: data.location.minutes,
                seconds: data.location.seconds,
                timezone: data.location.timezone,
                dlstime: 0
            )
            
            let roundedAzimuth = azimuth.rounded(toPlaces: 2)
            
            results.append(roundedAzimuth)
        }
        
        let zipped = Array(zip(expected, results))
        
        // Then
        zipped.forEach {
            XCTAssertEqual($0.0, $0.1)
        }
    }
    
    func testElevation() {
        // Given
        let expected = testData.map { $0.result.elevation }
        var results = [Double]()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // When
        for data in testData {
            let year = calendar.component(.year, from: data.location.date)
            let month = calendar.component(.month, from: data.location.date)
            let day = calendar.component(.day, from: data.location.date)
            
            let elevation = Solar.elevation(
                lat: data.location.latitude,
                lon: data.location.longitude,
                year: year,
                month: month,
                day: day,
                hours: data.location.hours,
                minutes: data.location.minutes,
                seconds: data.location.seconds,
                timezone: data.location.timezone,
                dlstime: 0
            )
            
            let roundedElevation = elevation.rounded(toPlaces: 2)
            
            results.append(roundedElevation)
        }
        
        let zipped = Array(zip(expected, results))
        
        // Then
        zipped.forEach {
            XCTAssertEqual($0.0, $0.1)
        }
    }
}
