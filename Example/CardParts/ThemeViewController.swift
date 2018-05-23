//
//  ThemeViewController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CardParts

class ThemeViewController: CardsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comment out one of the loadCard functions to change cards and/or their order
        
        // loadCards(cards: [Thing1CardController(), /*TestCardController(),*/ AnotherCardController(), Thing2CardController()])
        loadCards(cards: [TestCardController()])
    }
}
