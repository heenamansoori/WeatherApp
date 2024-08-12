//
//  TextFieldTests.swift
//  WeatherAppTests
//
//  Created by Heena Mansoori on 8/10/24.
//

import XCTest
@testable import WeatherApp

final class TextFieldTests: XCTestCase {
    var viewController: WeatherViewController!
    var textField: UITextField!

    override func setUp() {
    
        super.setUp()
         // Initialize your view controller
   
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyBoard.instantiateViewController(withIdentifier: "VC") as? WeatherViewController
        viewController.loadViewIfNeeded()
    
        textField = viewController.searchTextField
    }

    override func tearDown() {
        viewController = nil
        textField = nil
        super.tearDown()
        
    }
    func testTextFieldInput() {
        // Arrange
        let textField = viewController.searchTextField
        let inputText = "Paris"
        
        // Act
        textField?.text = inputText
        
        // Assert
        XCTAssertEqual(textField?.text, inputText, "TextField text should be updated.")
    }
 
    func testTextFieldShouldEndEditing() {
        let shouldReturn = viewController.textFieldShouldReturn(textField)
        if textField.text == nil {
            XCTAssertFalse(shouldReturn, "TextField should not return and continue editing")
        }else {
            XCTAssertTrue(shouldReturn, "TextField should return and end editing")
        }
 }
 
    func testTextFieldShouldReturn() {
     let shouldReturn = viewController.textFieldShouldReturn(textField)
     XCTAssertTrue(shouldReturn, "TextField should return and end editing")
 }
    
}
