//
//  WeatherManagerTests.swift
//  WeatherAppTests
//
//  Created by Heena Mansoori on 8/10/24.
//

import XCTest
@testable import WeatherApp


final class WeatherManagerTests: XCTestCase {
    class MockWeatherManagerDelegate: WeatherManagerDelegate {
     
        var didUpdateWeatherCalled = false
        var didFailWithErrorCalled = false
        var receivedWeather: WeatherModel?
        var receivedError: Error?
        
        
        var didFailToLoadImageCalled = false
        var didLoadImageCalled = false
        var imageError: Error?
        var loadedImage: UIImage?
        
        
        func didUpdateWeather(_ weatherManager: WeatherApp.WeatherManager, weather: WeatherApp.WeatherModel) {
            didUpdateWeatherCalled = true
            receivedWeather = weather
            
        }
        
        func didFailWithError(error: any Error) {
            didFailWithErrorCalled = true
            receivedError = error
        }
        
        func didLoadImage(_ image: UIImage?) {
            didLoadImageCalled = true
            loadedImage = image
        }
        
        func didFailToLoadImage(with error: any Error) {
            didFailToLoadImageCalled = true
            imageError = error
        }
        
    }
    
    var weatherManager: WeatherManager!
    var mockDelegate: MockWeatherManagerDelegate!
    
    override func setUp() {
        super.setUp()
        
        weatherManager = WeatherManager()
        mockDelegate = MockWeatherManagerDelegate()
        weatherManager.delegate = mockDelegate
    }
    
    override func tearDown() {
        weatherManager = nil
        mockDelegate = nil
        
        super.tearDown()
    }
    
    func testDelegateCalledWhenFetchingWeatherAsync() {
        
        let expectation = self.expectation(description: "Delegate method didUpdateWeather should be called")
        weatherManager.fetchWeather(cityName: "New York")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(self.mockDelegate.didUpdateWeatherCalled, "Delegate method didUpdateWeather should be called")
            XCTAssertNotNil(self.mockDelegate.receivedWeather, "Weather should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
        
    func testLoadImageSucess(){
        
        guard let testUrl = URL(string: "https://openweathermap.org/img/wn/10d@2x.png") else {
            XCTFail("Missing file")
            return
        }
        
        let expectation = self.expectation(description: "Image load should succeed")
        weatherManager.loadImage(from: testUrl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockDelegate.didLoadImageCalled, "Delegate method didLoadImage should be called")
            
            XCTAssertNotNil(self.mockDelegate.loadedImage, "Loaded Image should not be Nil")
            
            expectation.fulfill()
            
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    
    func testDidFailWithError() {
        let error = NSError(domain: "", code: 1001, userInfo: nil)
        weatherManager.delegate?.didFailWithError(error: error)
        
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled, "The delegate's didFailWithError method should be called")

        XCTAssertNotNil(mockDelegate.receivedError, "An error should be passed to the delegate")

        XCTAssertEqual((mockDelegate.receivedError as NSError?)?.code, 1001, "The error code should be 1001")
    }
    
    func testLoadImageFailure() {
        let testData: URL
        if let testUrl = URL(string: "htps://openweathermap.org/img/wn/10d@2x.png") {
           testData = testUrl
        }else {
            XCTAssert(self.mockDelegate.didFailToLoadImageCalled, "LOad image error")
            XCTAssertNotNil(mockDelegate.imageError, "An error should be passed to the delegate")
            return
        }
        
        weatherManager.loadImage(from: testData)
 
    }
 
}

