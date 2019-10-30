//
//  CardPartStackViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartStackViewCardController: CardPartsViewController {
    
    let cardPartSV = CardPartStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartSV.axis = .horizontal
        cardPartSV.distribution = .equalSpacing
        
        let cardPartTextView1 = CardPartTextView(type: .normal)
        cardPartTextView1.text = "This"
        cardPartTextView1.textColor = .systemPurple
        cardPartSV.addArrangedSubview(cardPartTextView1)
        
        let cardPartTextView2 = CardPartTextView(type: .normal)
        cardPartTextView2.text = "is"
        cardPartTextView2.textColor = .systemBlue
        cardPartSV.addArrangedSubview(cardPartTextView2)
        
        let cardPartTextView3 = CardPartTextView(type: .normal)
        cardPartTextView3.text = "a"
        cardPartTextView3.textColor = .systemOrange
        cardPartSV.addArrangedSubview(cardPartTextView3)
        
        let cardPartTextView4 = CardPartTextView(type: .normal)
        cardPartTextView4.text = "CardPartStackView"
        cardPartTextView4.textColor = .systemRed
        cardPartSV.addArrangedSubview(cardPartTextView4)
        
        setupCardParts([cardPartSV])
    }
}

