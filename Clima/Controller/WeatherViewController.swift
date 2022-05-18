//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Allows delegate functionality in this controller
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
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

