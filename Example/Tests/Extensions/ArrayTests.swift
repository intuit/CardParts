//
//  ArrayTests.swift
//  CardParts_Tests
//

import XCTest
@testable import CardParts

class ArrayExtesionTests: XCTestCase {

    func testSafeValue() {
        var array: [Int]
        
        // when array is empty
        array = []
        
        XCTAssertNil(array.safeValue(at: -1), "Should be nil for negative index")
        XCTAssertNil(array.safeValue(at: 0), "Should be nil for positive index if array is empty")
        XCTAssertNil(array.safeValue(at: Int.random(in: 1...100)), "Should be nil for positive index if array is empty")
        
        // when array is not empty
        array = [
            Int.random(in: 0...100),
            Int.random(in: 0...100),
            Int.random(in: 0...100)
        ]
        
        XCTAssertNil(array.safeValue(at: -1), "Should be nil for negative index")
        XCTAssertNil(array.safeValue(at: array.count), "Should be nil for positive index out of range")

        for index in 0..<array.count {
            XCTAssertEqual(array.safeValue(at: index), array[index])
        }
    }
}
