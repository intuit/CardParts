//
//  CardPartPillLabelCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 8/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class CardPartPillLabelCardController: CardPartsViewController {
    
    let stackView = CardPartStackView()
    let label1 = CardPartPillLabel()
    let label2 = CardPartPillLabel()
    let label3 = CardPartPillLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = "Label1"
        label1.verticalPadding = 10
        label1.horizontalPadding = 10
        label1.backgroundColor = UIColor.black
        label1.textColor = UIColor.white
        
        label2.text = "Label2"
        label2.verticalPadding = 10
        label2.horizontalPadding = 10
        label2.backgroundColor = UIColor.black
        label2.textColor = UIColor.white
        
        label3.text = "Label3"
        label3.verticalPadding = 10
        label3.horizontalPadding = 10
        label3.backgroundColor = UIColor.black
        label3.textColor = UIColor.white
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        [label1, label2, label3].forEach { label in
            stackView.addArrangedSubview(label)
        }

        setupCardParts([stackView])
    }
    
}
