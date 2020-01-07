//
//  CardPartBorderViewController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 7/31/19.
//  Copyright © 2019 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartBorderViewController: CardPartsViewController, BorderCardTrait, RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 4.0
    }
    
    func borderWidth() -> CGFloat {
        return 2.0
    }
    
    func borderColor() -> UIColor {
        return UIColor.systemGray
    }
    
    
    let sampleText = CardPartTextView(type: .title)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sampleText.text = "Border Card"
        
        setupCardParts([sampleText])
    }
}
