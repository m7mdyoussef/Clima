//
//  ViewController.swift
//  Clima
//
//  Created by mohamed youssef on 5/2/21.
//  Copyright © 2019 mohamed youssef. All rights reserved.
//

import UIKit
import CoreLocation //// 1

class WeatherViewController: UIViewController{
 
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() //// 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self  //// 3  delegate = self  -> arrangement important
        locationManager.requestWhenInUseAuthorization() /// 4   request user permession
        locationManager.requestLocation() //// 5  requestLocation  to call this method -> didUpdateLocations
        
        
        weatherManager.delegate = self  // 5- set protocol property = self
        searchTxtField.delegate = self  // ,UITextFieldDelegate and delegate == txtField tell view controller all the user interact with txtField
        
    }
    @IBAction func getCurrentLocationWeather(_ sender: UIButton) {
        locationManager.requestLocation() //// 5  requestLocation  to call this method -> didUpdateLocations
    }
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTxtField.endEditing(true) // dismiss keyboard
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // when return or go btn in keyboard pressed
        searchTxtField.endEditing(true) // dismiss keyboard

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != "" { // London press search or go
            return true                // so call textFieldDidEndEditing
        }else{
            textField.placeholder = "Type someThing" // empty txtField andpress search or go don't call textFieldDidEndEditing
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // use txtField to get city weather
        if let city = searchTxtField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        // when press return i end edititing
        searchTxtField.text = ""
    }
}


//MARK: - weatherManagerDelegate

extension WeatherViewController: weatherManagerDelegate{ // 4- conform protocol
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) { // 6- call protocol method which has the values inside
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
     }
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{ //// 6
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() // as soon as it's gotten hold a location
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
