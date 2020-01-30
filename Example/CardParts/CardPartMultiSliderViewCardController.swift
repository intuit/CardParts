//
//  CardPartMultiSliderViewCardController.swift
//  CardParts_Example
//
//  Created by bcarreon1  on 1/30/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class CardPartMultiSliderViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let cardPartMultiSliderView = CardPartMultiSliderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartMultiSliderView"
        
        cardPartMultiSliderView.minimumValue = 0
        cardPartMultiSliderView.maximumValue = 100
        cardPartMultiSliderView.value = [25, 75]
        cardPartMultiSliderView.orientation = .horizontal
        cardPartMultiSliderView.trackWidth = 8
        cardPartMultiSliderView.outerTrackColor = .gray
        cardPartMultiSliderView.tintColor = .blue
        
        setupCardParts([cardPartTextView, cardPartMultiSliderView])
    }
}
