//
//  CardPartTitleViewTests.swift
//  Gala
//
//  Created by Kier, Tom on 3/3/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import CardParts

class CardPartTitleViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTitleType() {
		
		let titlePart = CardPartTitleView(type: .titleOnly)
		XCTAssertNil(titlePart.button)
	}

	func testTitleProperty() {
		
		let bag = DisposeBag()
		
		let titlePart = CardPartTitleView(type: .titleOnly)
		titlePart.title = "hello"
		XCTAssertEqual(titlePart.title, titlePart.label.text)
		
		let titleProperty = Variable("testing")
		titleProperty.asObservable().bind(to: titlePart.rx.title).disposed(by: bag)
		XCTAssertEqual(titlePart.title, titlePart.label.text)
		
		titleProperty.value = "New Value"
		XCTAssertEqual(titlePart.title, titlePart.label.text)
	}
	
	func testTitleFontProperty() {
		
		let bag = DisposeBag()
		
		let titlePart = CardPartTitleView(type: .titleOnly)
		titlePart.title = "hello"

		titlePart.titleFont = UIFont.boldSystemFont(ofSize: 50)
		XCTAssertEqual(titlePart.titleFont, titlePart.label.font)

		let fontProperty = Variable(UIFont.boldSystemFont(ofSize: 20))
		fontProperty.asObservable().bind(to: titlePart.rx.titleFont).disposed(by: bag)
		XCTAssertEqual(titlePart.titleFont, titlePart.label.font)

		fontProperty.value = UIFont.boldSystemFont(ofSize: 30)
		XCTAssertEqual(titlePart.titleFont, titlePart.label.font)
    }

	func testTitleColorProperty() {
		
		let bag = DisposeBag()
		
		let titlePart = CardPartTitleView(type: .titleOnly)
		titlePart.title = "hello"

		titlePart.titleColor = UIColor.red
		XCTAssertEqual(titlePart.titleColor, titlePart.label.textColor)

		let titleColorProperty = Variable(UIColor.green)
		titleColorProperty.asObservable().bind(to: titlePart.rx.titleColor).disposed(by: bag)
		XCTAssertEqual(titlePart.titleColor, titlePart.label.textColor)

		titleColorProperty.value = UIColor.blue
		XCTAssertEqual(titlePart.titleColor, titlePart.label.textColor)
    }

	func testMenuTitleProperty() {
		
		let bag = DisposeBag()
		
		let titlePart = CardPartTitleView(type: .titleOnly)
		XCTAssertNil(titlePart.menuTitle)
		
		let menuTitleProperty = Variable("hello")
		menuTitleProperty.asObservable().bind(to: titlePart.rx.menuTitle).disposed(by: bag)
		XCTAssertEqual(titlePart.menuTitle, "hello")
		
		menuTitleProperty.value = "New Value"
		XCTAssertEqual(titlePart.menuTitle, "New Value")
	}

	func testMenuOptionsProperty() {
		
		let bag = DisposeBag()
		
		let titlePart = CardPartTitleView(type: .titleOnly)
		XCTAssertNil(titlePart.menuOptions)
		
		let menuOptionsProperty = Variable(["AAA", "BBB", "CCC"])
		menuOptionsProperty.asObservable().bind(to: titlePart.rx.menuOptions).disposed(by: bag)
		XCTAssertEqual(titlePart.menuOptions!, ["AAA", "BBB", "CCC"])
		
		menuOptionsProperty.value = ["111", "222"]
		XCTAssertEqual(titlePart.menuOptions!, ["111", "222"])
	}

	func testMenuButtonImageNameProperty() {
		
		let bag = DisposeBag()
		
		let titlePart = CardPartTitleView(type: .titleOnly)
		
		let buttonImageProperty = Variable("hello")
		buttonImageProperty.asObservable().bind(to: titlePart.rx.menuButtonImageName).disposed(by: bag)
		XCTAssertEqual(titlePart.menuButtonImageName, "hello")
		
		buttonImageProperty.value = "New Value"
		XCTAssertEqual(titlePart.menuButtonImageName, "New Value")
	}

}
