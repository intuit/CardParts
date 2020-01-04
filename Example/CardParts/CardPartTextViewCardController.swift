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
        
        cardPartTextView.attributedText = NSAttributedString(string: "This is a CardPartTextView")
//        let url: String = "https://www.google.com"
//        let attText = NSMutableAttributedString()
//
//        attText.append(NSAttributedString(string: "https://www.google.com"))
//        attText.addAttribute(.link, value: url, range: NSRange(location: 0, length: url.count))
//        cardPartTextView.attributedText = attText
        
        cardPartTextView.text = "Hello World"
        
        setupCardParts([cardPartTextView])
    }
}
