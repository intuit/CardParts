//
//  CardPartTextViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartTextViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartTextView"
        
        setupCardParts([cardPartTextView])
    }
}
