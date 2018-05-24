//
//  ThemeViewController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import UIKit
import CardParts

class ThemeViewController: CardsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comment out one of the loadCard functions to change cards and/or their order
        let cards: [CardPartsViewController] = [
            ThemedCardController(title: "These"),
            ThemedCardController(title: "Are"),
            ThemedCardController(title: "Themed"),
            ThemedCardController(title: "Cards!")
        ]
        
        loadCards(cards: cards)
    }
}
