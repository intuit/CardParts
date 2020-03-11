//
//  CardPartsBottomSheetTests.swift
//  CardParts_Tests
//
//  Created by Ryan Cole on 3/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

@testable import CardParts

class CardPartsBottomSheetTests: XCTestCase {
    
    var bottomSheetViewController: CardPartsBottomSheetViewController!
    var hostView: UIView!
    var presentExpectation: XCTestExpectation!
    var updateExpectation: XCTestExpectation!
    var dismissExpectation: XCTestExpectation!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        bottomSheetViewController = CardPartsBottomSheetViewController()
        bottomSheetViewController.contentVC = UIViewController()
        bottomSheetViewController.contentHeight = 100
        presentExpectation = XCTestExpectation(description: "bottom sheet finished presenting")
        updateExpectation = XCTestExpectation(description: "bottom sheet finished updating")
        dismissExpectation = XCTestExpectation(description: "bottom sheet finished dismissing")
        bottomSheetViewController.didShow = { self.presentExpectation.fulfill() }
        bottomSheetViewController.didChangeHeight = { newHeight in self.updateExpectation.fulfill() }
        bottomSheetViewController.didDismiss = { dismissalType in self.dismissExpectation.fulfill() }
        
        hostView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // test basic presenting bottom sheet, updating height, and dismissing.
    func testBottomSheet() {
        bottomSheetViewController.presentBottomSheet(on: hostView)
        wait(for: [presentExpectation], timeout: 2)
        
        [bottomSheetViewController.handleVC.view, bottomSheetViewController.contentVC?.view].forEach {
            XCTAssertNotNil($0?.gestureRecognizers)
        }
        
        bottomSheetViewController.contentHeight = 200
        wait(for: [updateExpectation], timeout: 2)
        
        XCTAssert(!bottomSheetViewController.view.constraints.isEmpty)
        XCTAssert(!bottomSheetViewController.view.subviews.isEmpty)
        XCTAssertNotNil(bottomSheetViewController.view.superview)
        
        bottomSheetViewController.dismissBottomSheet(.programmatic(info: nil))
        wait(for: [dismissExpectation], timeout: 2)
        
        XCTAssert(bottomSheetViewController.view.constraints.isEmpty)
        XCTAssert(bottomSheetViewController.view.subviews.isEmpty)
        XCTAssertNil(bottomSheetViewController.view.superview)
    }
    
    func testBottomSheetInsideHandle() {
        bottomSheetViewController.handlePosition = .inside(topPadding: 8)
        bottomSheetViewController.handleVC.handleColor = .blue
        bottomSheetViewController.handleVC.handleWidth = 30
        bottomSheetViewController.handleVC.handleHeight = 6
        
        bottomSheetViewController.presentBottomSheet(on: hostView)
        wait(for: [presentExpectation], timeout: 2)
        
        bottomSheetViewController.dismissBottomSheet(.tapInOverlay)
        wait(for: [dismissExpectation], timeout: 2)
    }
    
    func testStickyBottomSheet() {
        bottomSheetViewController.configureForStickyMode()
        bottomSheetViewController.addShadow()
        
        bottomSheetViewController.presentBottomSheet(on: hostView)
        wait(for: [presentExpectation], timeout: 2)
        
        [bottomSheetViewController.handleVC.view, bottomSheetViewController.contentVC?.view].forEach {
            XCTAssertNil($0?.gestureRecognizers)
        }
        
        bottomSheetViewController.dismissBottomSheet(.swipeDown)
        wait(for: [dismissExpectation], timeout: 2)
    }

}
