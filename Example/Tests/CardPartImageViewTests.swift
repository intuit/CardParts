//
//  CardPartImageViewTests.swift
//  Gala
//
//  Created by Kier, Tom on 3/3/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import CardParts

class CardPartImageViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testMenuOptionsProperty() {
		
		let bag = DisposeBag()
		
		let imagePart = CardPartImageView()
		
        let imageNameProperty = BehaviorRelay(value: "imageName")
		imageNameProperty.asObservable().bind(to: imagePart.rx.imageName).disposed(by: bag)
		XCTAssertEqual(imagePart.imageName, "imageName")
		
		imageNameProperty.accept("new value")
		XCTAssertEqual(imagePart.imageName, "new value")
	}

	func testContentModeProperty() {
		
		let bag = DisposeBag()
		
		let imagePart = CardPartImageView()
		
        let contentModeProperty = BehaviorRelay<UIView.ContentMode>(value: .scaleToFill)
		contentModeProperty.asObservable().bind(to: imagePart.rx.contentMode).disposed(by: bag)
		XCTAssertEqual(imagePart.contentMode, UIView.ContentMode.scaleToFill)
		
		contentModeProperty.accept(.scaleAspectFit)
		XCTAssertEqual(imagePart.contentMode, UIView.ContentMode.scaleAspectFit)
	}

}
