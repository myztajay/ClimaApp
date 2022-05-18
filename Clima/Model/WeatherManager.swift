//
//  WeatherManager.swift
//  Clima
//
//  Created by Rafael Fernandez on 5/17/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didWeatherUpdate (_ weatherManager: WeatherManager,_ weather: WeatherModel)
    func didFailWithError (_ error: Error)
}

struct WeatherManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=44ea42967b627e5d041106235be0242a"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        var urlString = "\(baseURL)&q=\(cityName)"
        performRequest(with: urlString)
        print(cityName)
    }
    func performRequest(with urlString: String){
        if let url = URL(string: urlString) {
            // setting up session
            let session = URLSession(configuration: .default)
            // api requestion with handler
            let task = session.dataTask(with: url) {data, response, error in
                //error checking
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                // printing response if we have one
                if let safeData = data {
                    if let weather = parseJSON(safeData){
                        // triggering parent / delgate method here
                        self.delegate?.didWeatherUpdate(self, weather)
                    }
                }
            }
            // all tasks start suspended
            task.resume()
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel?{
        // choose decoder
        let decoder = JSONDecoder()
        // do try blocks and error handling
        do {
            // decoder takes itself as an argument
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            
            let id  = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            // instantiate weather model
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weatherModel
        } catch {
            print(error)
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
