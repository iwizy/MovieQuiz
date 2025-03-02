//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Alexander Agafonov on 28.02.2025.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
                
        app.terminate()
        app = nil
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(secondPoster.exists)
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(secondPoster.exists)
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testIndexLabel() {
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
    
    func testAlert() {
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        app.buttons["Yes"].tap()
        sleep(2)
        
        let alert = app.alerts["AlertPresenter"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
        
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
