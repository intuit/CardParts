//
//  CardUtilsTests.swift
//  CardParts_Tests
//
//  Created by Tumer, Deniz on 5/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import CardParts

class CardUtilsTests: XCTestCase {
    
    // tests if the card is visible (normal case)
    func testIsCardVisibleForRatio() {
        let containerFrame = CGRect(x: 0, y: 0, width: 300, height: 1000)
        let cardFrame = CGRect(x: 0, y: 0, width: 280, height: 100)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 1.0)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.1)
    }
    
    // tests if half of the card is visible (top is visible)
    func testIsCardVisibleForRatioHalfTop() {
        let containerFrame = CGRect(x: 0, y: 0, width: 300, height: 1000)
        let cardFrame = CGRect(x: 0, y: 950, width: 280, height: 100)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 0.5)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.05)
    }
    
    // tests if the card is visible (bottom half is visible)
    func testIsCardVisibleForRatioHalfBottom() {
        let containerFrame = CGRect(x: 0, y: 0, width: 300, height: 1000)
        let cardFrame = CGRect(x: 0, y: -50, width: 280, height: 100)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 0.5)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.05)
    }
    
    // tests if there isnt half of the card showing
    func testIsCardVisibleForRatioNotVisible1() {
        let containerFrame = CGRect(x: 0, y: 0, width: 300, height: 1000)
        let cardFrame = CGRect(x: 0, y: -75, width: 280, height: 100)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 0.25)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.025)
    }
    
    // tests if there isnt half of the card showing (slightly less than half the bottom of the card is showing)
    func testIsCardVisibleForRatioNotVisible2() {
        let containerFrame = CGRect(x: 0, y: 0, width: 300, height: 100)
        let cardFrame = CGRect(x: 0, y: -51, width: 280, height: 100)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 0.49)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.49)
    }
    
    // tests if there isnt half of the card showing (top part of card is showing)
    func testIsCardVisibleForRatioNotVisible3() {
        let containerFrame = CGRect(x: 0, y: 0, width: 300, height: 1000)
        let cardFrame = CGRect(x: 0, y: 960, width: 280, height: 100)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 0.4)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.04)
    }
    
    // tests card in full view in different area of scroll view
    func testIsCardVisibleTrue1() {
        let containerFrame = CGRect(x: 0, y: 621, width: 375, height: 760)
        let cardFrame = CGRect(x: 12.0, y: 691, width: 351, height: 380)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 1.0)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.5)
    }
    
    // tests card cut off at top of screen in different area of scroll view
    func testCardNotVisible() {
        let containerFrame = CGRect(x: 0, y: 621.5, width: 375, height: 603.1)
        let cardFrame = CGRect(x: 12.0, y: 400.5, width: 351.0, height: 386.5)
        let visibleHeight = cardFrame.height - (containerFrame.origin.y - cardFrame.origin.y)
        let calcCardVisibility = visibleHeight / cardFrame.height
        let calcContainerCoverage = visibleHeight / containerFrame.height
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, calcCardVisibility)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, calcContainerCoverage)
    }
    
    // tests card cut off at bottom of screen in different area of scroll view
    func testIsCardVisibleCutOffBottom() {
        let containerFrame = CGRect(x: 0, y: 621.5, width: 375, height: 603.1)
        let cardFrame = CGRect(x: 12.0, y: 1050, width: 351.0, height: 386.5)
        let visibleHeight = containerFrame.origin.y + containerFrame.height - cardFrame.origin.y
        let calcCardVisibility = visibleHeight / cardFrame.height
        let calcContainerCoverage = visibleHeight / containerFrame.height
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, calcCardVisibility)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, calcContainerCoverage)
    }
    
    // tests card cut off at bottom of screen in different area of scroll view
    func testIsCardVisibleCutOffBottom1() {
        let containerFrame = CGRect(x: 0, y: 621.5, width: 375, height: 603.1)
        let cardFrame = CGRect(x: 12.0, y: 1060, width: 351.0, height: 300.5)
        let visibleHeight = containerFrame.origin.y + containerFrame.height - cardFrame.origin.y
        let calcCardVisibility = visibleHeight / cardFrame.height
        let calcContainerCoverage = visibleHeight / containerFrame.height
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, calcCardVisibility)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, calcContainerCoverage)
    }
    
    // tests if card is not in view below current scroll view bounds
    func testIsCardNotVisibleBelowScrollViewBounds() {
        let containerFrame = CGRect(x: 0, y: 33.0, width: 375, height: 603.0)
        let cardFrame = CGRect(x: 12.0, y: 691.5, width: 351.0, height: 386.5)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 0.0)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.0)
    }
    
    // test card not in view above current scroll view bounds
    func testIsCardNotVisibleAboveScrollViewBounds() {
        let containerFrame = CGRect(x: 0, y: 885, width: 375, height: 603.0)
        let cardFrame = CGRect(x: 12.0, y: 691.5, width: 351.0, height: 386.5)
        let visibleHeight = cardFrame.height - (containerFrame.origin.y - cardFrame.origin.y)
        let calcCardVisibility = visibleHeight / cardFrame.height
        let calcContainerCoverage = visibleHeight / containerFrame.height
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, calcCardVisibility)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, calcContainerCoverage)
    }
    
    // test card visible at edge above
    func testIsCardVisibleAboveScrollViewAtEdge() {
        let containerFrame = CGRect(x: 0, y: 750, width: 375, height: 600)
        let cardFrame = CGRect(x: 12.0, y: 600, width: 351.0, height: 300)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 0.5)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.25)
    }
    
    // test card visible at edge below
    func testIsCardVisibleBelowScrollViewAtEdge() {
        let containerFrame = CGRect(x: 0, y: 450, width: 375, height: 600)
        let cardFrame = CGRect(x: 12.0, y: 600, width: 351.0, height: 300)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerFrame, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 1.0)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 0.5)
    }
    
    // test card cut off at top and bottom (card too big for container)
    func testIsCardVisibleTooLarge() {
        let containerBounds = CGRect(x: 0, y: 0, width: 400, height: 700)
        let cardFrame = CGRect(x: 0, y: -20, width: 400, height: 1400)
        let visibilityRatios = CardUtils.calculateVisibilityRatios(containerFrame: containerBounds, cardFrame: cardFrame)
        
        XCTAssertEqual(visibilityRatios.cardVisibilityRatio, 0.5)
        XCTAssertEqual(visibilityRatios.containerCoverageRatio, 1.0)
    }
}

// tests for is significant scroll
extension CardUtilsTests {
    
    // tests that we don't reach the threshold value in our scroll positively
    func testNotSignificantScrollPositive() {
        let lastScrollBounds = CGRect(x: 0, y: 0, width: 375, height: 1800)
        let currentScrollBounds = CGRect(x: 0, y: 9, width: 375, height: 1800)
        let threshold: CGFloat = 10.0
        
        XCTAssertFalse(CardUtils.isSignificantScroll(lastScrollBounds: lastScrollBounds, currentScrollBounds: currentScrollBounds, threshold: threshold))
    }
    
    // tests that we don't reach the threshold value of our scroll negatively
    func testNotSignificantScrollNegative() {
        let lastScrollBounds = CGRect(x: 0, y: 0, width: 375, height: 1800)
        let currentScrollBounds = CGRect(x: 0, y: -8, width: 375, height: 1800)
        let threshold: CGFloat = 10.0
        
        XCTAssertFalse(CardUtils.isSignificantScroll(lastScrollBounds: lastScrollBounds, currentScrollBounds: currentScrollBounds, threshold: threshold))
    }
    
    // tests that we do reach the threshold value of our scroll positively
    func testSignificantScrollPositive() {
        let lastScrollBounds = CGRect(x: 0, y: 0, width: 375, height: 1800)
        let currentScrollBounds = CGRect(x: 0, y: 20, width: 375, height: 1800)
        let threshold: CGFloat = 10.0
        
        XCTAssertTrue(CardUtils.isSignificantScroll(lastScrollBounds: lastScrollBounds, currentScrollBounds: currentScrollBounds, threshold: threshold))
    }
    
    // tests that we do reach the threshold value of our scroll negatively
    func testSignificantScrollNegative() {
        let lastScrollBounds = CGRect(x: 0, y: 0, width: 375, height: 1800)
        let currentScrollBounds = CGRect(x: 0, y: -20, width: 375, height: 1800)
        let threshold: CGFloat = 10.0
        
        XCTAssertTrue(CardUtils.isSignificantScroll(lastScrollBounds: lastScrollBounds, currentScrollBounds: currentScrollBounds, threshold: threshold))
    }
    
    // tests nil last scroll bounds
    func testNilLastScroll() {
        let lastScrollBounds: CGRect? = nil
        let currentScrollBounds = CGRect(x: 0, y: -20, width: 375, height: 1800)
        let threshold: CGFloat = 10.0
        
        XCTAssertTrue(CardUtils.isSignificantScroll(lastScrollBounds: lastScrollBounds, currentScrollBounds: currentScrollBounds, threshold: threshold))
    }
}
