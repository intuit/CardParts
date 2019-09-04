//
//  CardPartConfettiViewCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 9/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts


class CardPartConfettiViewCardController: CardPartsViewController {
    
    override func viewDidLoad() {
        
        let confettiView = CardPartConfettiView(frame: self.view.bounds)
        
        self.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        self.view.addSubview(confettiView)
        
        //setupCardParts([confettiView])
    }
}
