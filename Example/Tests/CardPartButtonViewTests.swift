//
//  CardPartButtonViewTests.swift
//  Gala
//
//  Created by Kier, Tom on 3/3/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import CardParts

class CardPartButtonViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testContentHorizontalAlignmentProperty() {
		
		let bag = DisposeBag()
		
		let buttonPart = CardPartButtonView()
		XCTAssertEqual(buttonPart.contentHorizontalAlignment, UIControl.ContentHorizontalAlignment.left)
		
        let horizAlignProperty = BehaviorRelay<UIControl.ContentHorizontalAlignment>(value: .right)
		horizAlignProperty.asObservable().bind(to: buttonPart.rx.contentHorizontalAlignment).disposed(by: bag)
		XCTAssertEqual(buttonPart.contentHorizontalAlignment, UIControl.ContentHorizontalAlignment.right)
		
		horizAlignProperty.accept(.center)
		XCTAssertEqual(buttonPart.contentHorizontalAlignment, UIControl.ContentHorizontalAlignment.center)
	}
	
}
