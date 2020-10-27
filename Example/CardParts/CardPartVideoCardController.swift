//
//  CardPartVideoCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 10/26/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class CardPartVideoCardController: CardPartsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoUrl = URL(string: "https://offcnt.intuit.com/videos/US/Jerry/09.30.20_Outsourced_Animated_1920x1080_30s_FB_V9.mp4")  else  { return }
        
        let cardPartVideoView = CardPartVideoView(videoUrl: videoUrl)
        cardPartVideoView.configureVideo(for: self)
        
        setupCardParts([cardPartVideoView])
    }
}

