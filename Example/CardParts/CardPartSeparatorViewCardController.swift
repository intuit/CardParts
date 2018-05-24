//
//  CardPartSeparatorViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//


import Foundation
import CardParts

class CardPartSeparatorViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let cardPartSeparatorView = CardPartSeparatorView()
    let cardPartTextView2 = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "Below is a CardPartSeperatorView"
        cardPartTextView2.text = "Viola!"
        
        setupCardParts([cardPartTextView, cardPartSeparatorView, cardPartTextView2])
    }
}
