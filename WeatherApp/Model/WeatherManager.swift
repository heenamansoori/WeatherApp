//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Heena Mansoori on 8/9/24.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    func didLoadImage(_ image: UIImage?)
    func didFailToLoadImage(with error: Error)
    
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid={Your API KEY}&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    //fetch by cityName 
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    //fetch by location
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session: URLSession = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            if let url = URL(string: weather.iconString) {
                                loadImage(from: url)
                            }
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let description = decodedData.weather[0].description
            let icon = decodedData.weather[0].icon
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, weatherDescription: description, iconName: icon)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    self.delegate?.didLoadImage(image)
                }
                if let error = error {
                    self.delegate?.didFailToLoadImage(with: error)
                    return
                }
        }
        task.resume()
    }
}
