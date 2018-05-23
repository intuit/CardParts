//
//  MainViewController.swift
//  CardParts
//
//  Created by tkier on 11/27/2017.
//  Copyright (c) 2017 tkier. All rights reserved.
//

import UIKit
import CardParts

class MainViewController: CardsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comment out one of the CardPartViewController in the card Array to change cards and/or their order
        let cards: [CardPartsViewController] = [
            CardPartTextViewCardController(), // Text
            CardPartImageViewCardController(), // Image
            CardPartButtonViewCardController(), // Button
            CardPartTitleViewCardController(), // Titles
            CardPartSeparatorViewCardController(), // Separator
            CardPartStackViewCardController(), // UIStackView
            CardPartTableViewCardController(), // UITableView
            CardPartCollectionViewCardController(), // UICollectionView
            CardPartBarViewCardController(), // Bar
            CardPartPagedViewCardController(), // Pages
            CardPartSliderViewCardController(), // Slider
            CardPartTextFieldCardController(), // TextField
        ]
        
        loadCards(cards: cards)
    }
}

