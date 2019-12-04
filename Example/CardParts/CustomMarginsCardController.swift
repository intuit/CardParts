//
//  CustomMarginsCardController.swift
//  CardParts_Example
//
//  Created by Jonathan Jordan on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class CustomMarginsCardController: CardPartsViewController, CustomMarginCardTrait {
    
    let cardPartTextView = CardPartTextView(type: .title)
    
    func customMargin() -> CGFloat {
        return 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This card has custom margins"
        cardPartTextView.textAlignment = .center
        setupCardParts([cardPartTextView])
    }
}
