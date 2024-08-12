//
//  MockURLSession.swift
//  WeatherAppTests
//
//  Created by Heena Mansoori on 8/10/24.
//

import Foundation

// A mock URLSession class
class MockURLSession: URLSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        // Create a mock task and call the completion handler with the mock data
        let task = MockURLSessionDataTask {
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        }
        return task
    }
}

// A mock URLSessionDataTask class
class MockURLSessionDataTask: URLSessionDataTask {
    private let completionHandler: () -> Void

    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }

    override func resume() {
        // Simulate the completion of the task
        completionHandler()
    }
}
