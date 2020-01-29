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
    
    private var currentPage = 0
    private var timer: Timer?
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let emojis: [String] = ["😎", "🤪", "🤩", "👻", "🤟🏽", "💋", "💃🏽"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartPagedView"
        
        var stackViews: [CardPartStackView] = []
        
        for (index, emojiString) in emojis.enumerated() {
            
            let sv = CardPartStackView()
            sv.axis = .vertical
            sv.spacing = 8
            stackViews.append(sv)
            
            let title = CardPartTextView(type: .normal)
            title.text = "This is page #\(index)"
            title.textAlignment = .center
            sv.addArrangedSubview(title)
            
            let emoji = CardPartTextView(type: .normal)
            emoji.text = emojiString
            emoji.textAlignment = .center
            sv.addArrangedSubview(emoji)
        }
        
        let cardPartPagedView = CardPartPagedView(withPages: stackViews, andHeight: 200)
        
        // To animate through the pages
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {[weak self] (_) in
            
            guard let this = self else { return }
            this.currentPage = this.currentPage == this.emojis.count - 1 ? 0 : this.currentPage + 1
            cardPartPagedView.moveToPage(this.currentPage)
        })
        
        setupCardParts([cardPartTextView, cardPartPagedView])
    }
}
