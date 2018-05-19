//
//  ViewController.swift
//  CardParts
//
//  Created by tkier on 11/27/2017.
//  Copyright (c) 2017 tkier. All rights reserved.
//

import UIKit
import CardParts

class ViewController: CardsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comment out one of the loadCard functions to change cards and/or their order
        
        // loadCards(cards: [Thing1CardController(), /*TestCardController(),*/ AnotherCardController(), Thing2CardController()])
        loadCards(cards: [TestCardController()])
    }
}

