//
//  MainViewController.swift
//  CardParts
//
//  Created by tkier on 11/27/2017.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import CardParts

class MainViewController: CardsViewController {

    required init?(coder: NSCoder) {
        // Override point for customization after application launch.
        // Uncomment the following to try use our custom theme.
//        CardPartsCustomTheme().apply()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comment out one of the CardPartViewController in the card Array to change cards and/or their order
        let cards: [CardPartsViewController] = [
            CardPartBottomSheetCardController(), // Bottom sheet examples
            CardPartTextViewCardController(), // Text, built on UILabel
            CardPartAttributedTextViewController(), // Text, built on UITextView
            CardPartTitleDescriptionViewCardController(), // Title/Description
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
            CardPartMultiSliderViewCardController(), // MultiSlider
            CardPartTextFieldCardController(), // TextField
            CardPartOrientedViewCardController(), // Oriented card part
            CardPartCenteredViewCardController(), // Centered card part
            ReactiveCardController(), // Demo RxSwift
            StateCardController(), // Demo states
            CardPartBorderViewController(), // Border Cards
            CardPartPillLabelCardController(), // Pill label
            CardPartRoundedStackViewCardController(), //Rounded Stackview
            CardPartIconLabelCardController(), // Icon label
            CardPartProgressBarViewCardController(), // ProgresBarView
            CardPartMapViewCardController(), // MapView
            CardPartRadioButtonCardController(), // Radio Button
            CardPartHistogramCardController(), // Histogram
            CardPartCustomMarginsCardController(), // Custom margins trait
            CardPartSwitchViewCardController() // Switch
        ]
        
        loadCards(cards: cards)
    }
}

