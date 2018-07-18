//
//  CardPartTitleDescriptionViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 7/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class CardPartTitleDescriptionViewCardController: CardPartsViewController {
    
    let cardPartTitleDescriptionViewRight = CardPartTitleDescriptionView(titlePosition: .top, secondaryPosition: .right)
    let cardPartTitleDescriptionViewCenter = CardPartTitleDescriptionView(titlePosition: .top, secondaryPosition: .center(amount: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTitleDescriptionViewRight.leftTitleText = "Look at my alignemnt"
        cardPartTitleDescriptionViewRight.rightTitleText = ".right aligned!"
        
        cardPartTitleDescriptionViewCenter.leftTitleText = "Look now!"
        cardPartTitleDescriptionViewCenter.rightTitleText = ".center aligned"
        
        setupCardParts([cardPartTitleDescriptionViewRight, cardPartTitleDescriptionViewCenter])
    }
}

