//
//  ArrayTests.swift
//  MovieQuiz
//
//  Тест для хелпера массива

import Foundation
import XCTest

@testable import MovieQuiz



class ArrayTests: XCTestCase {
    // Успешное взятие элемента массива
    func testGetValueInRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }

    // неуспешное взятие элемента массива, индекс за пределами массива
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        // When
        let value = array[safe: 20]
        // Then
        XCTAssertNil(value)
    }
}
