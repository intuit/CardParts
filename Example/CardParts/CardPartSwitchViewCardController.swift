//
//  CardPartSwitchViewCardController.swift
//  CardParts_Example
//
//  Created by bcarreon1  on 2/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CardParts

class CardPartSwitchViewCardController: CardPartsViewController {
    
    let cardPartSwitch = CardPartSwitchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartSwitch.onTintColor = .blue
        
        setupCardParts([cardPartSwitch])
    }
}
