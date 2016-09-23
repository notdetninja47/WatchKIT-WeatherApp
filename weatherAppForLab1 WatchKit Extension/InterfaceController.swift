//
//  InterfaceController.swift
//  weatherAppForLab1 WatchKit Extension
//
//  Created by Daniel on 21.09.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import WatchKit
import Foundation


enum TemperatureMetrics: String {
    case c = "℃"
    case f = "℉"
    case degreeSymbol = "°"
}
class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    @IBOutlet var weatherIcon: WKInterfaceImage!
    @IBOutlet var currentTemperatureLabel: WKInterfaceLabel!
    @IBOutlet var highestTemperatureLabel: WKInterfaceLabel!
    @IBOutlet var lowestTemperatureLabel: WKInterfaceLabel!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    @IBOutlet var timeTravelLabel: WKInterfaceLabel!
    
    private var weatherIconCode = "" {
        didSet{
            let image = UIImage(named: weatherIconCode)
            weatherIcon.setImage(image)
        }
    }
    private var currentMetrics: TemperatureMetrics = .c
    private func cToF(_ c:Int)->Int{
        return c*9/5+32
    }
    private var currentTemperature: Int = 0 {
        didSet{
            if currentMetrics == .f {
                currentTemperatureLabel.setText("\(cToF(currentTemperature)) " + currentMetrics.rawValue)
            } else {
                currentTemperatureLabel.setText("\(currentTemperature) " + currentMetrics.rawValue)
            }
        }
    }
    private var highestTemperature: Int = 0 {
        didSet{
            if currentMetrics == .f {
                highestTemperatureLabel.setText("H: \(cToF(highestTemperature)) " + TemperatureMetrics.degreeSymbol.rawValue)
            } else {
                highestTemperatureLabel.setText("H: \(highestTemperature) " + TemperatureMetrics.degreeSymbol.rawValue)
            }
        }
    }
    private var lowestTemperature: Int = 0 {
        didSet{
            if currentMetrics == .f {
                lowestTemperatureLabel.setText("L: \(cToF(lowestTemperature)) " + TemperatureMetrics.degreeSymbol.rawValue)
            } else {
                lowestTemperatureLabel.setText("L: \(lowestTemperature) " + TemperatureMetrics.degreeSymbol.rawValue)
            }
        }
    }
    
    private var descriptionText: String = "" {
        didSet{
            descriptionLabel.setText(descriptionText)
        }
    }
    
    var currentWeatherBuffer: WeatherInfoChunk?
    var weatherInfo: WeatherInfoChunk? {
        didSet{
            if let weather = weatherInfo{
                weatherIconCode = weather.iconCode
                descriptionText = weather.description
                currentTemperature = weather.temperature
            
                AdditionalPageInterfaceController.currentWeatherData = weatherInfo
            }
        }
    }
    var forecastInfo: DailyWeatherInfo? {
        didSet {
            if forecastInfo != nil {
                let HL = countHLTemps()
                highestTemperature = HL.highest
                lowestTemperature = HL.lowest
            }
        }
    }
    
    func countHLTemps() -> (highest: Int, lowest: Int) {
        var lowestTemp = forecastInfo!.forecast[0].weather.temperature
        var highestTemp = forecastInfo!.forecast[0].weather.temperature
        for i in 0...forecastInfo!.forecast.count - 1 {
            if lowestTemp > forecastInfo!.forecast[i].weather.temperature {
                lowestTemp = forecastInfo!.forecast[i].weather.temperature
            }
            if highestTemp < forecastInfo!.forecast[i].weather.temperature {
                highestTemp = forecastInfo!.forecast[i].weather.temperature
            }
        }
        return (highestTemp, lowestTemp)
    }
    
    func reloadData() {
        OpenWeatherApi.getWeather(inCity: "Kharkiv", units: .c){
            (weatherInfo) in
            self.currentWeatherBuffer = weatherInfo
            self.weatherInfo = weatherInfo
        }
        OpenWeatherApi.getForecast(inCity: "Kharkiv", units: .c){
            (forecastInfo) in
            print("\n\n\n\nforecastInfo is loaded")
            self.forecastInfo = forecastInfo
        }
    }

    @IBAction func switchUnits() {
        if currentMetrics == .c {
            currentMetrics = .f
        } else {
            currentMetrics = .c
        }
        currentTemperature = currentTemperature + 0
        highestTemperature = highestTemperature + 0
        lowestTemperature = lowestTemperature + 0
    }
    
    
    override func willActivate() {
        super.willActivate()
        reloadData()
        crownSequencer.delegate = self
        crownSequencer.focus()
    }
    
    var totalDelta:Int = 0
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        if rotationalDelta > 0.125 || rotationalDelta < -0.125 {
            if let forecast = forecastInfo?.forecast{
                totalDelta = totalDelta + Int(rotationalDelta*8)
                if totalDelta > forecast.count - 1{
                    totalDelta = forecast.count - 1
                } else if totalDelta <= 0 {
                    totalDelta = 0
                    timeTravelLabel.setText("now")
                    weatherInfo = currentWeatherBuffer
                } else {
                    timeTravelLabel.setText(forecast[totalDelta-1].time)
                    weatherInfo = forecast[totalDelta-1].weather
                }
            }
        }
    }
}
