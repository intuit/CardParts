//
//  CardPartRoundedStackViewCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 8/2/19.
//  Copyright © 2019 Intuit. All rights reserved.
//

import Foundation
import CardParts
import UIKit

class CardPartRoundedStackViewCardController: CardPartsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = CardPartTextView(type: .title)
        textView.text = "Card Parts"
        
        let cardPartsImage = CardPartImageView(image: UIImage(named: "cardIcon"))
        cardPartsImage.contentMode = .scaleAspectFit
        
        let roundedStackView = CardPartStackView()
        roundedStackView.axis = .horizontal
        roundedStackView.spacing = 10.0
        //margins are like leading , trailing , top & bottom anchors
        roundedStackView.margins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100)
        roundedStackView.isLayoutMarginsRelativeArrangement = true
        roundedStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        roundedStackView.cornerRadius = 10.0
        roundedStackView.backgroundView.backgroundColor = UIColor(red: 16.0 / 255.0, green: 128.0 / 255.0, blue: 0, alpha: 0.16)
        roundedStackView.pinBackground(roundedStackView.backgroundView, to: roundedStackView)
        
        roundedStackView.addArrangedSubview(textView)
        roundedStackView.addArrangedSubview(cardPartsImage)
        
        setupCardParts([roundedStackView])
    }
}
