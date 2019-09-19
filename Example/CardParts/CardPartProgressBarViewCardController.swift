//
//  CardPartProgressBarViewCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 9/19/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class CardPartProgressBarViewCardController: CardPartsViewController {
    
    let barColors: [UIColor] = [UIColor.sunflowerYellow,
                                UIColor.kiwiGreen,
                                UIColor.darkLimeGreen,
                                UIColor.kermitGreen,
                                UIColor.trueGreen]
    
    let barValues: [Double] = [300, 600, 650, 700, 750, 850]
    
    override func viewDidLoad() {
        let progressBarView = CardPartProgressBarView(barValues: barValues, barColors: barColors, marker: nil, markerLabelTitle: "", currentValue: Double(720), showShowBarValues: false)
        progressBarView.barCornerRadius = 4.0
        setupCardParts([progressBarView])
    }
}
