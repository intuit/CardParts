//
//  CardPartTextViewTests.swift
//  Gala
//
//  Created by Kier, Tom on 3/2/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import CardParts


class CardPartTextViewTests: XCTestCase {
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testTextType() {

		var textPart = CardPartTextView(type: .normal)
		textPart.text = "hello"
		XCTAssertEqual(textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as? UIFont, CardParts.theme.normalTextFont)
		XCTAssertEqual(textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as? UIColor, CardParts.theme.normalTextColor)

		textPart = CardPartTextView(type: .title)
		textPart.text = "hello"
		XCTAssertEqual(textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as? UIFont, CardParts.theme.titleTextFont)
		XCTAssertEqual(textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as? UIColor, CardParts.theme.titleTextColor)
		
		textPart = CardPartTextView(type: .detail)
		textPart.text = "hello"
		XCTAssertEqual(textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as? UIFont, CardParts.theme.detailTextFont)
		XCTAssertEqual(textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as? UIColor, CardParts.theme.detailTextColor)
	}
    
    func testTextProperty() {
		
		let bag = DisposeBag()
		
		let textPart = CardPartTextView(type: .title)
		textPart.text = "hello"
		XCTAssertEqual("hello", textPart.label.text)
		
		let textProperty = Variable("testing")
        textProperty.asObservable().bind(to: textPart.rx.text).disposed(by: bag)
		XCTAssertEqual("testing", textPart.label.text)

		textProperty.value = "newValue"
		XCTAssertEqual("newValue", textPart.label.text)
    }

	func testAttributedTextProperty() {
		
		let bag = DisposeBag()
		
		let textPart = CardPartTextView(type: .title)
		let attrText = NSAttributedString(string: "hello", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 50), NSForegroundColorAttributeName : UIColor.red])

		textPart.attributedText = attrText
		XCTAssertEqual(attrText.string, textPart.label.attributedText?.string)
		XCTAssertEqual(attrText.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as! UIFont,
		               textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as! UIFont)
		XCTAssertEqual(attrText.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as! UIColor,
					   textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as! UIColor)
		
		let textProperty = Variable(NSAttributedString(string: "testing", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 50), NSForegroundColorAttributeName : UIColor.blue]))
        textProperty.asObservable().bind(to: textPart.rx.attributedText).disposed(by: bag)
		XCTAssertEqual(textProperty.value.string, textPart.label.attributedText?.string)
		XCTAssertEqual(textProperty.value.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as! UIFont,
					   textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as! UIFont)
		XCTAssertEqual(textProperty.value.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as! UIColor,
					   textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as! UIColor)

		textProperty.value = NSAttributedString(string: "newValue", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 50), NSForegroundColorAttributeName : UIColor.green])
		XCTAssertEqual(textProperty.value.string, textPart.label.attributedText?.string)
		XCTAssertEqual(textProperty.value.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as! UIFont,
					   textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as! UIFont)
		XCTAssertEqual(textProperty.value.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as! UIColor,
					   textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as! UIColor)
    }

	func testFontProperty() {
		
		let bag = DisposeBag()
		
		let textPart = CardPartTextView(type: .title)
		textPart.text = "hello"

		textPart.font =  UIFont.boldSystemFont(ofSize: 20)
		XCTAssertEqual(textPart.font, textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as? UIFont)

		let fontProperty = Variable(UIFont.boldSystemFont(ofSize: 50))
		fontProperty.asObservable().bind(to: textPart.rx.font).disposed(by: bag)
		XCTAssertEqual(fontProperty.value, textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as? UIFont)

		fontProperty.value = UIFont.boldSystemFont(ofSize: 10)
		XCTAssertEqual(fontProperty.value, textPart.label.attributedText?.attribute(NSFontAttributeName, at:0, effectiveRange:nil) as? UIFont)
    }

	func testTextColorProperty() {
		
		let bag = DisposeBag()
		
		let textPart = CardPartTextView(type: .title)
		textPart.text = "hello"

		textPart.textColor =  UIColor.red
		XCTAssertEqual(textPart.textColor, textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as? UIColor)

		let colorProperty = Variable(UIColor.green)
		colorProperty.asObservable().bind(to: textPart.rx.textColor).disposed(by: bag)
		XCTAssertEqual(colorProperty.value, textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as? UIColor)

		colorProperty.value = UIColor.blue
		XCTAssertEqual(colorProperty.value, textPart.label.attributedText?.attribute(NSForegroundColorAttributeName, at:0, effectiveRange:nil) as? UIColor)
    }

	func testTextAlignmentProperty() {
		
		let bag = DisposeBag()
		
		let textPart = CardPartTextView(type: .title)
		textPart.text = "hello"

		textPart.textAlignment = .right
		XCTAssertEqual(textPart.textAlignment, textPart.label.textAlignment)

		let alignProperty = Variable<NSTextAlignment>(.center)
		alignProperty.asObservable().bind(to: textPart.rx.textAlignment).disposed(by: bag)
		XCTAssertEqual(alignProperty.value, textPart.label.textAlignment)

		alignProperty.value = .left
		XCTAssertEqual(alignProperty.value, textPart.label.textAlignment)
    }

	func testLineSpacingProperty() {
		
		let bag = DisposeBag()
		
		let textPart = CardPartTextView(type: .title)
		textPart.text = "hello"

		textPart.lineSpacing = 5.0
		XCTAssertEqual(textPart.lineSpacing, (textPart.label.attributedText?.attribute(NSParagraphStyleAttributeName, at:0, effectiveRange:nil) as? NSParagraphStyle)?.lineSpacing)

		let lineSpacingProperty = Variable<CGFloat>(2.5)
		lineSpacingProperty.asObservable().bind(to: textPart.rx.lineSpacing).disposed(by: bag)
		XCTAssertEqual(textPart.lineSpacing, (textPart.label.attributedText?.attribute(NSParagraphStyleAttributeName, at:0, effectiveRange:nil) as? NSParagraphStyle)?.lineSpacing)

		lineSpacingProperty.value = 1.0
		XCTAssertEqual(textPart.lineSpacing, (textPart.label.attributedText?.attribute(NSParagraphStyleAttributeName, at:0, effectiveRange:nil) as? NSParagraphStyle)?.lineSpacing)
    }

	func testLineHeightMultipleProperty() {
		
		let bag = DisposeBag()
		
		let textPart = CardPartTextView(type: .title)
		textPart.text = "hello"

		textPart.lineHeightMultiple = 5.0
		XCTAssertEqual(textPart.lineHeightMultiple, (textPart.label.attributedText?.attribute(NSParagraphStyleAttributeName, at:0, effectiveRange:nil) as? NSParagraphStyle)?.lineHeightMultiple)

		let lineHeightMultipleProperty = Variable<CGFloat>(2.5)
		lineHeightMultipleProperty.asObservable().bind(to: textPart.rx.lineHeightMultiple).disposed(by: bag)
		XCTAssertEqual(textPart.lineHeightMultiple, (textPart.label.attributedText?.attribute(NSParagraphStyleAttributeName, at:0, effectiveRange:nil) as? NSParagraphStyle)?.lineHeightMultiple)

		lineHeightMultipleProperty.value = 1.0
		XCTAssertEqual(textPart.lineHeightMultiple, (textPart.label.attributedText?.attribute(NSParagraphStyleAttributeName, at:0, effectiveRange:nil) as? NSParagraphStyle)?.lineHeightMultiple)
    }

}
