//
//  ViewController.swift
//  macOS Example
//
//  Created by Dmitry on 14.05.21.
//

import Cocoa
import SharedSolar

class ViewController: NSViewController {
    @IBOutlet weak var cityLabel: NSTextField!
    @IBOutlet weak var longitudeLabel: NSTextField!
    @IBOutlet weak var latitudeLabel: NSTextField!
    @IBOutlet weak var timezoneLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    
    @IBOutlet weak var sunriseLabel: NSTextField!
    @IBOutlet weak var sunsetLabel: NSTextField!
    @IBOutlet weak var solarNoonLabel: NSTextField!
    @IBOutlet weak var azimuthLabel: NSTextField!
    @IBOutlet weak var elevationLabel: NSTextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let result = service.calculate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        cityLabel.stringValue = city.name
        latitudeLabel.stringValue = "Latitude: \(city.latitude)"
        longitudeLabel.stringValue = "Longitude: \(city.longitude)"
        timezoneLabel.stringValue = "Timezone: UTC \(dayTime.timezone)"
        dateLabel.stringValue = "Date: \(dateFormatter.string(from: dayTime.date))"
        timeLabel.stringValue = "Time: \(dayTime.hours)h \(dayTime.minutes)m \(dayTime.seconds)s"
        
        sunriseLabel.stringValue = "Sunrise: \(result.sunrise)"
        sunsetLabel.stringValue = "Sunset: \(result.sunset)"
        solarNoonLabel.stringValue = "Solar Noon: \(result.solarNoon)"
        azimuthLabel.stringValue = "Azimuth: \(result.azimuth)"
        elevationLabel.stringValue = "Elevation: \(result.elevation)"
    }
}
