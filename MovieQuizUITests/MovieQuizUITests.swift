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
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
                
        app.terminate()
        app = nil
    }

    @MainActor
    
    // тест кнопки ДА, сравнение постеров при смене вопроса и проверка смены лейбла индекса после смены вопроса
    func testYesButton() {
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons["Yes"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    // тест кнопку НЕТ, сравнение постеров при смене вопроса и проверка смены лейбла индекса после смены вопроса
    func testNoButton() {
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons["No"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testIndexLabel() {
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
    
    func testAlert() {
        sleep(2)
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["AlertPresenter"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertButton() {
        sleep(2)
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["AlertPresenter"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
