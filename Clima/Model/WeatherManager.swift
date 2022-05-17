//
//  WeatherManager.swift
//  Clima
//
//  Created by Rafael Fernandez on 5/17/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=44ea42967b627e5d041106235be0242a"
    
    func fetchWeather(cityName: String){
        var urlString = "\(baseURL)&q=\(cityName)"
        performRequest(urlString: urlString)
        print(cityName)
    }
    func performRequest(urlString: String){
        if let url = URL(string: urlString) {
            // setting up session
            let session = URLSession(configuration: .default)
            // api requestion with handler
            let task = session.dataTask(with: url) {data, response, error in
                //error checking
                if error != nil {
                    print(error)
                    return
                }
                // printing response if we have one
                if let safeData = data {
                    parseJSON(weatherData: safeData)
                }
            }
            // all tasks start suspended
            task.resume()
        }
    }
    
    func parseJSON (weatherData: Data){
        // choose decoder
        let decoder = JSONDecoder()
        // do try blocks and error handling
        do {
            // decoder takes itself as an argument
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
        
    }
}
