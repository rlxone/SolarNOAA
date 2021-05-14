//
//  City.swift
//  SharedSolar
//
//  Created by Dmitry on 14.05.21.
//

import Foundation
import SolarNOAA

public struct City {
    public let name: String
    public let longitude: Double
    public let latitude: Double
    
    public init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}
