//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Allows delegate functionality in this controller
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// Breaking apart UI text field functionality
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        var input = searchTextField.text
        searchTextField.endEditing(true)
        print(input!)
    }
    // delegate action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    // a check of wether or not they have text
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return searchTextField.text != ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // this assignment will assure there is a value so that later there will be no need to unwrap.
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

// weather manager functionality
extension WeatherViewController: WeatherManagerDelegate {
    func didWeatherUpdate(_ weatherManager: WeatherManager,_ weather: WeatherModel){
        print("\(weather.temperature) from the controller")
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    // request user permission
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = lastLocation.coordinate.latitude
            let lon = lastLocation.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fail")
    }
}
