//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Allows delegate functionality in this controller
        searchTextField.delegate = self
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
    // a check of wether or
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return searchTextField.text != ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
}

