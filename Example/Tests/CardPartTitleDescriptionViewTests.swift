//
//  CardPartTitleDescriptionViewTests.swift
//  CardParts_Tests
//
//  Created by Kier, Tom on 12/8/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import CardParts

class CardPartTitleDescriptionViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLeftTitle() {
        
        let cell = CardPartTitleDescriptionView()
        XCTAssertEqual(cell.leftTitleFont, CardParts.theme.leftTitleFont)
        XCTAssertEqual(cell.leftTitleLabel.font, CardParts.theme.leftTitleFont)
        XCTAssertEqual(cell.leftTitleColor, CardParts.theme.leftTitleColor)
        XCTAssertEqual(cell.leftTitleLabel.textColor, CardParts.theme.leftTitleColor)
        
        cell.leftTitleFont = UIFont.boldSystemFont(ofSize: 20)
        XCTAssertEqual(cell.leftTitleLabel.font, UIFont.boldSystemFont(ofSize: 20))
        
        cell.leftTitleColor = UIColor.red
        XCTAssertEqual(cell.leftTitleLabel.textColor, UIColor.red)
    }
    
    func testLeftDescription() {
        
        let cell = CardPartTitleDescriptionView()
        XCTAssertEqual(cell.leftDescriptionFont, CardParts.theme.leftDescriptionFont)
        XCTAssertEqual(cell.leftDescriptionLabel.font, CardParts.theme.leftDescriptionFont)
        XCTAssertEqual(cell.leftDescriptionColor, CardParts.theme.leftDescriptionColor)
        XCTAssertEqual(cell.leftDescriptionLabel.textColor, CardParts.theme.leftDescriptionColor)
        
        cell.leftDescriptionFont = UIFont.boldSystemFont(ofSize: 20)
        XCTAssertEqual(cell.leftDescriptionLabel.font, UIFont.boldSystemFont(ofSize: 20))
        
        cell.leftDescriptionColor = UIColor.red
        XCTAssertEqual(cell.leftDescriptionLabel.textColor, UIColor.red)
    }
    
    func testRightTitle() {
        
        let cell = CardPartTitleDescriptionView()
        XCTAssertEqual(cell.rightTitleFont, CardParts.theme.rightTitleFont)
        XCTAssertEqual(cell.rightTitleLabel.font, CardParts.theme.rightTitleFont)
        XCTAssertEqual(cell.rightTitleColor, CardParts.theme.rightTitleColor)
        XCTAssertEqual(cell.rightTitleLabel.textColor, CardParts.theme.rightTitleColor)
        
        cell.rightTitleFont = UIFont.boldSystemFont(ofSize: 20)
        XCTAssertEqual(cell.rightTitleLabel.font, UIFont.boldSystemFont(ofSize: 20))
        
        cell.rightTitleColor = UIColor.red
        XCTAssertEqual(cell.rightTitleLabel.textColor, UIColor.red)
    }
    
    func testRightDescription() {
        
        let cell = CardPartTitleDescriptionView()
        XCTAssertEqual(cell.rightDescriptionFont, CardParts.theme.rightDescriptionFont)
        XCTAssertEqual(cell.rightDescriptionLabel.font, CardParts.theme.rightDescriptionFont)
        XCTAssertEqual(cell.rightDescriptionColor, CardParts.theme.rightDescriptionColor)
        XCTAssertEqual(cell.rightDescriptionLabel.textColor, CardParts.theme.rightDescriptionColor)
        
        cell.rightDescriptionFont = UIFont.boldSystemFont(ofSize: 20)
        XCTAssertEqual(cell.rightDescriptionLabel.font, UIFont.boldSystemFont(ofSize: 20))
        
        cell.rightDescriptionColor = UIColor.red
        XCTAssertEqual(cell.rightDescriptionLabel.textColor, UIColor.red)
    }
    
}
