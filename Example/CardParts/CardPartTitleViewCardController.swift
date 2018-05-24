//
//  CardPartTitleViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartTitleViewCardController: CardPartsViewController {
    
    let cardPartTitleView = CardPartTitleView(type: .titleOnly)
    let cardPartTitleWithMenu = CardPartTitleView(type: .titleWithMenu)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTitleView.title = "I am a standard .titleOnly CardPartTitleView"
        cardPartTitleWithMenu.title = "I am a .titleWithMenu CardPartTitleView"
        
        setupCardParts([cardPartTitleView, cardPartTitleWithMenu])
    }
}

