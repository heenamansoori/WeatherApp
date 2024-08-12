//
//  WeatherManagerNetworkTests.swift
//  WeatherAppTests
//
//  Created by Heena Mansoori on 8/10/24.
//

import XCTest
@testable import WeatherApp


final class WeatherManagerNetworkTests: XCTestCase {

        var weatherManager: WeatherManager!
        var mockSession: MockURLSession!

        override func setUp() {
            super.setUp()
            mockSession = MockURLSession()
            weatherManager = WeatherManager() // Assume WeatherManager accepts a session
        }

        override func tearDown() {
            mockSession = nil
            weatherManager = nil
            super.tearDown()
        }

        func testFetchWeatherSuccess() {
            let json = """
            {
                "temperature": 20.0
            }
            """
            mockSession.data = json.data(using: .utf8)
            mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
            let expectation = self.expectation(description: "Fetch weather")
            weatherManager.performRequest(with: )
            weatherManager.fetchWeather { result in
                switch result {
                case .success(let weather):
                    XCTAssertEqual(weather.temperature, 20.0)
                case .failure(let error):
                    XCTFail("Expected success but got error: \(error)")
                }
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1, handler: nil)
        }

        func testFetchWeatherFailure() {
            mockSession.error = NSError(domain: "", code: 404, userInfo: nil)
            let expectation = self.expectation(description: "Fetch weather failure")

            weatherManager.fetchWeather { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual((error as NSError).code, 404)
                }
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1, handler: nil)
        }
    }



