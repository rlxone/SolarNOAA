//
//  Helpers.swift
//  SolarNOAA
//
//  Created by Dmitry on 15.05.21.
//

import Foundation

extension Date {
    init(day: Int, month: Int, year: Int) {
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        let date = Calendar.current.date(from: dateComponents)!
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
