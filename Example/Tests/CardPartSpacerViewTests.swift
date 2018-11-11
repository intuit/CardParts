//
//  CardPartSpacerViewTests.swift
//  Gala
//
//  Created by Kier, Tom on 3/3/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import CardParts

class CardPartSpacerViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testIntrinsicContentSize() {
		
		let spacerPart = CardPartSpacerView(height: 50.0)
		XCTAssertEqual(spacerPart.intrinsicContentSize.width, UIView.noIntrinsicMetric)
		XCTAssertEqual(spacerPart.intrinsicContentSize.height, 50.0)
	}
	
}
