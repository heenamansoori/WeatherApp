//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Heena Mansoori on 8/9/24.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    
}

struct Weather: Codable {
    let description: String
    let id: Int
    let icon: String
}
