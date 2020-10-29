//
//  CardPartVideoControllerTests.swift
//  CardParts_Tests
//
//  Created by Venkatnarayansetty, Badarinath on 10/26/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

@testable import CardParts

class CardPartVideoControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCardPartVideoView() throws {
        guard let videoUrl = URL(string: "https://offcnt.intuit.com/videos/US/Jerry/09.30.20_Outsourced_Animated_1920x1080_30s_FB_V9.mp4")  else  { return }
        
        let cardPartVideoView = CardPartVideoView(videoUrl: videoUrl)
        XCTAssertEqual(cardPartVideoView.playerHeight, 300)
    }

}
