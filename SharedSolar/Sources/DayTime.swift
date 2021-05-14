//
//  DayTime.swift
//  SharedSolar
//
//  Created by Dmitry on 14.05.21.
//

import Foundation

public struct DayTime {
    public let timezone: Int
    public let date: Date
    public let hours: Int
    public let minutes: Int
    public let seconds: Int
    
    public init(timezone: Int, date: Date, hours: Int, minutes: Int, seconds: Int) {
        self.timezone = timezone
        self.date = date
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
}
