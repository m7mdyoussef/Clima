//
//  WeatherManager.swift
//  Clima
//
//  Created by mohamed youssef on 5/2/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//


import Foundation
import CoreLocation
protocol weatherManagerDelegate { // 1- create protocol
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4f2a9ac5e63045d8bae36cd2fef1c78e&units=metric"
 
    var delegate: weatherManagerDelegate? // 2- create protocol property
    
    func fetchWeather(cityName: String)  {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)

    }
    
    func performRequest(urlString: String) {
        //1- create URL
        if let url = URL(string: urlString) {
           //2- create URL session
            let session = URLSession(configuration: .default)
            //3- give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(wetherData: safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather) // 3- implement protocol methods
                        }
                    }
            }
            //4- start the task
            task.resume()
        }
    }
    
    func parseJSON(wetherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(WeatherData.self, from: wetherData)
            print(decoderData.weather[0].description)
            let id = decoderData.weather[0].id
            let temp = decoderData.main.temp
            let name = decoderData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print( weather.conditionName) // depend on conditionId stored in struct
            print(weather.temperatureString)
            
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

    
    
}
