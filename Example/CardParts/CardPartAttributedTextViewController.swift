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
    let cardPartImage = CardPartImageView(image: UIImage(named: "cardIcon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let url: String = "https://github.com/intuit/CardParts"

        cardPartAttributedTextView.textAlignment = .left
        let explanation = NSMutableAttributedString(string: "This is a card part for text built off UITextView instead of UILabels. What's the difference you may ask? Well, for one thing, CardPartAttributedTextView supports text wrapping. In addition, this part allows for links to be imbedded and subsequently followed. Text selection is disabled.")
        explanation.addAttribute(.link, value: url, range: NSRange(location: 212, length: 20))
        
        cardPartAttributedTextView.attributedText = explanation
        cardPartAttributedTextView.gestureRecognizers?.forEach({ (gestureRecognizer) in
            gestureRecognizer.isEnabled = true
        })
        
        cardPartImage.contentMode = .center
        cardPartAttributedTextView.addSubview(cardPartImage)
        cardPartAttributedTextView.textViewImage = cardPartImage
        
        let exclusionPath = UIBezierPath(rect: cardPartImage.frame)
        cardPartAttributedTextView.exclusionPath?.append(exclusionPath)
        
        setupCardParts([cardPartAttributedTextView])
    }
}
