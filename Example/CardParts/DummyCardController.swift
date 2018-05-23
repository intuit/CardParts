//
//  DummyCardController.swift
//  CardParts_Example
//
//  Created by Tumer, Deniz on 5/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class DummyCardController: CardPartsViewController {
    
    var cardParts = [CardPartView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for ndx in 1...7 {
            let textView = CardPartTextView(type: .normal)
            textView.label.text = "Testing\(ndx)"
            cardParts.append(textView)
        }
        
        setupCardParts(cardParts)
    }
}
