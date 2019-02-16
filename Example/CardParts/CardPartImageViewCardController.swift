//
//  CardPartImageViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartImageViewCardController: CardPartsViewController, CardVisibilityDelegate {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let cardPartTextLogView = CardPartTextView(type: .normal)
    let cardPartImage = CardPartImageView(image: UIImage(named: "cardPartsLogo"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartImageView"
        cardPartTextLogView.text = "PS - Check the Xcode logs while you scroll this card!"
        
        cardPartImage.contentMode = .scaleAspectFit
        cardPartImage.addConstraint(NSLayoutConstraint(item: cardPartImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 300))
        
        setupCardParts([cardPartTextView, cardPartTextLogView, cardPartImage])
    }
    
    // allows us access to see the ratio of visibility of this card and the container coverage ratio
    // This is only called when the visibility of the card changes
    func cardVisibility(cardVisibilityRatio: CGFloat, containerCoverageRatio: CGFloat) {
        print("This card is \(cardVisibilityRatio *  100)% visible! It takes up \(containerCoverageRatio * 100)% of its container!")
    }
}

