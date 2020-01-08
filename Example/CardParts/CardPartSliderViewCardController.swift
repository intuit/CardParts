//
//  CardPartSliderViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartSliderViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let cardPartSliderView = CardPartSliderView(height: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartSliderView"
        
        cardPartSliderView.minimumValue = 0
        cardPartSliderView.maximumValue = 100
        cardPartSliderView.value = 50
        cardPartSliderView.minimumTrackTintColor = .blue
        cardPartSliderView.maximumTrackTintColor = .green
        
        setupCardParts([cardPartTextView, CardPartSpacerView(height: 10), cardPartSliderView])
    }
}
