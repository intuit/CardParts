//
//  CardPartPagedViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartPagedViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let emojis: [String] = ["😎", "🤪", "🤩", "👻", "🤟🏽", "💋", "💃🏽"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartPagedView"
        
        var stackViews: [CardPartStackView] = []
        
        for i in 0...10 {
            
            let sv = CardPartStackView()
            sv.axis = .vertical
            sv.spacing = 8
            stackViews.append(sv)
            
            let title = CardPartTextView(type: .normal)
            title.text = "This is page #\(i)"
            title.textAlignment = .center
            sv.addArrangedSubview(title)
            
            let emoji = CardPartTextView(type: .normal)
            emoji.text = self.emojis[Int(arc4random_uniform(UInt32(self.emojis.count)))]
            emoji.textAlignment = .center
            sv.addArrangedSubview(emoji)
        }
        
        let cardPartPagedView = CardPartPagedView(withPages: stackViews, andHeight: 200)
        
        setupCardParts([cardPartTextView, cardPartPagedView])
    }
}
