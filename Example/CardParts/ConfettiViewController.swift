//
//  ConfettiViewController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 9/4/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class ConfettiViewController: CardsViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        let cards:[CardPartsViewController] = [ CardPartConfettiViewCardController() ]
        
        self.loadCards(cards:cards )
    }
}
