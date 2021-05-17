//
//  InterfaceController.swift
//  watchOS Example WatchKit Extension
//
//  Created by Dmitry on 14.05.21.
//

import WatchKit
import Foundation
import SharedSolar

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var cityLabel: WKInterfaceLabel!
    @IBOutlet weak var longitudeLabel: WKInterfaceLabel!
    @IBOutlet weak var latitudeLabel: WKInterfaceLabel!
    @IBOutlet weak var timezoneLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    @IBOutlet weak var sunriseLabel: WKInterfaceLabel!
    @IBOutlet weak var sunsetLabel: WKInterfaceLabel!
    @IBOutlet weak var solarNoonLabel: WKInterfaceLabel!
    @IBOutlet weak var azimuthLabel: WKInterfaceLabel!
    @IBOutlet weak var elevationLabel: WKInterfaceLabel!
    
    let city = City(
        name: "Chicago",
        longitude: -87.623177,
        latitude: 41.881832
    )
    
    let dayTime = DayTime(
        timezone: -5,
        date: Date(),
        hours: 12,
        minutes: 0,
        seconds: 0
    )
    
    lazy var service = Service(
        city: city,
        dayTime: dayTime
    )
    
    override func awake(withContext context: Any?) {
        setupView()
    }
    
    func setupView() {
        let result = service.calculate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        cityLabel.setText(city.name)
        latitudeLabel.setText("Latitude: \(city.latitude)")
        longitudeLabel.setText("Longitude: \(city.longitude)")
        timezoneLabel.setText("Timezone: UTC \(dayTime.timezone)")
        dateLabel.setText("Date: \(dateFormatter.string(from: dayTime.date))")
        timeLabel.setText("Time: \(dayTime.hours)h \(dayTime.minutes)m \(dayTime.seconds)s")
        
        sunriseLabel.setText("Sunrise: \(result.sunrise)")
        sunsetLabel.setText("Sunset: \(result.sunset)")
        solarNoonLabel.setText("Solar Noon: \(result.solarNoon)")
        azimuthLabel.setText("Azimuth: \(result.azimuth)")
        elevationLabel.setText("Elevation: \(result.elevation)")
    }
}
