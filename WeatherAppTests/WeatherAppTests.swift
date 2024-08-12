//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Heena Mansoori on 8/9/24.
//

import XCTest
@testable import WeatherApp

final class WeatherAppTests: XCTestCase {

    var weatherManager: WeatherManager!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherManager = WeatherManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUrl(){
        let url =  "https://api.openweathermap.org/data/2.5/weather?appid=7d490cbfe44b2b90ecc17315286e2e47&units=metric"
        weatherManager.performRequest(with: url)
    }



}
