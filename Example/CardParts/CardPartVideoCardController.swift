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
        
        guard let videoUrl = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")  else  { return }
        
        let cardPartVideoView = CardPartVideoView(videoUrl: videoUrl)
        cardPartVideoView.configureVideo(for: self)
        
        setupCardParts([cardPartVideoView])
    }
}

