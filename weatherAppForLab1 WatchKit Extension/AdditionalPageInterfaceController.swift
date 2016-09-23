//
//  AdditionalPageInterfaceController.swift
//  weatherAppForLab1
//
//  Created by Daniel on 23.09.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import WatchKit
import Foundation


class AdditionalPageInterfaceController: WKInterfaceController {

    static var currentWeatherData: WeatherInfoChunk?
    
    @IBOutlet var pressureLabel: WKInterfaceLabel!
    @IBOutlet var humidityLabel: WKInterfaceLabel!
    @IBOutlet var cloudsLabel: WKInterfaceLabel!
    @IBOutlet var windLabel: WKInterfaceLabel!
    
    var pressure: Int = 0 {
        didSet{
            pressureLabel.setText("\(pressure) hPa")
        }
    }
    var humidity: Int = 0{
        didSet{
            humidityLabel.setText("\(humidity) %")
        }
    }
    var clouds: Int = 0{
        didSet{
            cloudsLabel.setText("\(clouds) %")
        }
    }
    var wind: Float = 0.0{
        didSet{
            windLabel.setText("\(wind) m/s")
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

    }

    override func willActivate() {
        super.willActivate()
        if let weather = AdditionalPageInterfaceController.currentWeatherData {
            pressure = weather.pressure
            humidity = weather.humidity
            clouds = weather.clouds
            wind = weather.speedOfWind
        }
    }
    
    

}
