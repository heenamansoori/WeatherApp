//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Heena Mansoori on 8/9/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherDescription: UILabel!
    
  
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupDefaultText()
        setupDelegates()

            }
    
    func setupBackgroundView() {
        let backgroundView = UIImageView(frame:view.bounds)
        backgroundView.image = UIImage(named: "light_background")
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
    }
    
    func setupDelegates() {
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func setupDefaultText() {
        // Load last searched text
              if let lastSearchText = UserDefaults.standard.string(forKey: "lastSearchText") {
                  weatherManager.fetchWeather(cityName: lastSearchText)
              }
    }
    
   
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        
    }
}

extension WeatherViewController: WeatherManagerDelegate {

    func didLoadImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.weatherConditionImageView.image = image
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.weatherDescription.text = weather.weatherDescription
        }
        // storing data to defaults once displayed
        UserDefaults.standard.set(weather.cityName, forKey: "lastSearchText")
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didFailToLoadImage(with error: any Error) {
        DispatchQueue.main.async {
            self.weatherConditionImageView.image = UIImage(named: "sun.max")
        }
        print(error)
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
