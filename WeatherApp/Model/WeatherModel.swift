//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Heena Mansoori on 8/9/24.
//

import Foundation
import UIKit

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let weatherDescription: String
    let iconName: String
    
    
    //No decimal place
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
        
    var iconString: String {
        return "https://openweathermap.org/img/wn/"+"\(iconName)"+"@2x.png"
    }

}
