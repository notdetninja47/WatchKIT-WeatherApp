import Foundation

enum Units: String {
    case c = "metric"
    case f = "imperial"
}

struct WeatherInfoChunk {
    let temperature: Int
    
    let pressure: Int
    let humidity: Int
    let clouds: Int
    let speedOfWind: Float
    
    let description: String
    let iconCode: String
    
    init(withDictionary weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["main"]!["temp"] as! Int
        pressure = weatherDictionary["main"]!["pressure"] as! Int
        humidity = weatherDictionary["main"]!["humidity"] as! Int
        clouds = weatherDictionary["clouds"]!["all"] as! Int
        speedOfWind = weatherDictionary["wind"]!["speed"] as! Float
        
        print("\n\n\n\n\n \((weatherDictionary["weather"] as! [AnyObject])[0])")
        
        if let weatherSubdictionary = (weatherDictionary["weather"] as! [AnyObject])[0] as? [String: AnyObject]
        {
            description = weatherSubdictionary["description"] as! String
            iconCode = weatherSubdictionary["icon"] as! String
        } else {
            description = ""
            iconCode = ""
        }
    }
}

struct DailyWeatherInfo {
    let forecast: [(time: String, weather: WeatherInfoChunk)]
    
    init(withListDictionaries listDictionaries: [[String: AnyObject]]) {
        var forecastValue: [(time: String, weather: WeatherInfoChunk)] = []
        for i in 1...9 {
            var time = listDictionaries[i]["dt_txt"] as! String
            time = time.substring(from: time.characters.index(of: " ")!)
            time = time.substring(to: time.index(time.endIndex, offsetBy: -3))
            
            forecastValue.append((time: "\(time)", weather: WeatherInfoChunk(withDictionary: listDictionaries[i])))
        }
        forecast = forecastValue
    }
}


class OpenWeatherApi {

    private struct Settings {
        static let openWeatherMapBaseWeatherURL = "http://api.openweathermap.org/data/2.5/weather"
        static let openWeatherMapBaseForecastURL = "http://api.openweathermap.org/data/2.5/forecast"
        static let openWeatherMapAPIKey = "f099f849a59277aaa5312f6089d873d9"
    }
    
    static func getWeather(inCity city: String, units: Units, callback: @escaping (WeatherInfoChunk)->()){
        let session = URLSession.shared
        let weatherRequestURL = URL(string: "\(Settings.openWeatherMapBaseWeatherURL)?APPID=\(Settings.openWeatherMapAPIKey)&q=\(city)&units=\(units.rawValue)")!

        let dataTask = session.dataTask(with: weatherRequestURL as URL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            }
            else {
                do {
                    let weatherDictionary = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! [String: AnyObject]
                    callback(WeatherInfoChunk(withDictionary: weatherDictionary))
                } catch let jsonError as NSError {
                    print("JSON error description: \(jsonError.description)")
                }

            }
        }
        dataTask.resume()
    }
    
    static func getForecast(inCity city: String, units: Units, callback: @escaping (DailyWeatherInfo)->()){
        let session = URLSession.shared
        let weatherRequestURL = URL(string: "\(Settings.openWeatherMapBaseForecastURL)?APPID=\(Settings.openWeatherMapAPIKey)&q=\(city)&units=\(units.rawValue)")!
        
        
        let dataTask = session.dataTask(with: weatherRequestURL as URL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            }
            else {
               do {
                    let weatherDictionary = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! [String: AnyObject]
                
                    if let listDictionaries = weatherDictionary["list"] as? [[String:AnyObject]] {
                        callback(DailyWeatherInfo(withListDictionaries: listDictionaries))
                    }
                } catch let jsonError as NSError {
                    print("JSON error description: \(jsonError.description)")
                }
            }
        }
        dataTask.resume()
    }
}
