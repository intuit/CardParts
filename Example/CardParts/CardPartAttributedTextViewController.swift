//
//  CardPartMutableTextViewController.swift
//  CardParts_Example
//
//  Created by jloehr  on 12/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class CardPartAttributedTextViewController: CardPartsViewController {
    
    let cardPartAttributedTextView = CardPartAttributedTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url: String = "https://www.google.com"
        let attText = NSMutableAttributedString()
        
        attText.append(NSAttributedString(string: "https://www.google.com"))
        attText.addAttribute(.link, value: url, range: NSRange(location: 0, length: url.count))
        cardPartAttributedTextView.attributedText = attText
        
        cardPartAttributedTextView.text = "Whatup Universe, click me"
        
        setupCardParts([cardPartAttributedTextView])
    }
}
