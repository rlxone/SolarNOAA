//
//  Data.swift
//  SolarTests
//
//  Created by Dmitry on 15.05.21.
//

import Foundation

typealias TestData = (location: TestLocation, result: TestResult)

struct TestLocation {
    let name: String
    let longitude: Double
    let latitude: Double
    let timezone: Int
    let date: Date
    let hours: Int
    let minutes: Int
    let seconds: Int
}

struct TestResult {
    let sunrise: String
    let sunset: String
    let azimuth: Double
    let elevation: Double
    let solarNoon: String
}

let testData: [TestData] = [
    (
        TestLocation(
            name: "Chicago",
            longitude: -87.623177,
            latitude: 41.881832,
            timezone: -5,
            date: Date(day: 14, month: 5, year: 2021),
            hours: 12,
            minutes: 0,
            seconds: 0
        ),
        TestResult(
            sunrise: "05:31",
            sunset: "20:03",
            azimuth: 153.11,
            elevation: 64.87,
            solarNoon: "12:46:50"
        )
    ),
    (
        TestLocation(
            name: "New York",
            longitude: -73.935242,
            latitude: 40.73061,
            timezone: -4,
            date: Date(day: 14, month: 5, year: 2021),
            hours: 12,
            minutes: 0,
            seconds: 0
        ),
        TestResult(
            sunrise: "05:39",
            sunset: "20:05",
            azimuth: 149.19,
            elevation: 65.39,
            solarNoon: "12:52:05"
        )
    ),
    (
        TestLocation(
            name: "Berlin",
            longitude: 13.404954,
            latitude: 52.520008,
            timezone: 2,
            date: Date(day: 14, month: 5, year: 2021),
            hours: 12,
            minutes: 0,
            seconds: 0
        ),
        TestResult(
            sunrise: "05:11",
            sunset: "20:54",
            azimuth: 154.14,
            elevation: 54.07,
            solarNoon: "13:02:44"
        )
    ),
    (
        TestLocation(
            name: "Beijing",
            longitude: 116.383331,
            latitude: 39.916668,
            timezone: 8,
            date: Date(day: 14, month: 5, year: 2021),
            hours: 12,
            minutes: 0,
            seconds: 0
        ),
        TestResult(
            sunrise: "05:00",
            sunset: "19:21",
            azimuth: 172.95,
            elevation: 68.63,
            solarNoon: "12:10:49"
        )
    ),
    (
        TestLocation(
            name: "Minsk",
            longitude: 27.567444,
            latitude: 53.893009,
            timezone: 3,
            date: Date(day: 14, month: 5, year: 1999),
            hours: 12,
            minutes: 0,
            seconds: 0
        ),
        TestResult(
            sunrise: "05:10",
            sunset: "21:03",
            azimuth: 153.77,
            elevation: 52.45,
            solarNoon: "13:06:03"
        )
    )
]
