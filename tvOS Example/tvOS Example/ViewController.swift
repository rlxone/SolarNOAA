//
//  ViewController.swift
//  tvOS Example
//
//  Created by Dmitry on 14.05.21.
//

import UIKit
import SharedSolar

class ViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var solarNoonLabel: UILabel!
    @IBOutlet weak var azimuthLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    
    let city = City(
        name: "Chicago",
        longitude: -98.583,
        latitude: 39.833
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
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        
        cityLabel.text = city.name
        latitudeLabel.text = "Latitude: \(city.latitude)"
        longitudeLabel.text = "Longitude: \(city.longitude)"
        timezoneLabel.text = "Timezone: GMT \(dayTime.timezone)"
        dateLabel.text = "Date: \(dateFormatter.string(from: dayTime.date))"
        timeLabel.text = "Time: \(dayTime.hours)h \(dayTime.minutes)m \(dayTime.seconds)s"
        
        sunriseLabel.text = "Sunrise: \(result.sunrise)"
        sunsetLabel.text = "Sunset: \(result.sunset)"
        solarNoonLabel.text = "Solar Noon: \(result.solarNoon)"
        azimuthLabel.text = "Azimuth: \(result.azimuth)"
        elevationLabel.text = "Elevation: \(result.elevation)"
    }
}

