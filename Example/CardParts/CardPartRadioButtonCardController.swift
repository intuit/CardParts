//
//  CardPartRadioButtonCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 10/23/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts
import RxSwift
import RxCocoa

class CardPartRadioButtonCardController : CardPartsViewController {

    let firstRowStackView = CardPartStackView()
    let secondRowStackView = CardPartStackView()
    let firstLabel = CardPartLabel()
    let secondLabel = CardPartLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstRowStackView.axis = .horizontal
        firstRowStackView.spacing = 8
        firstRowStackView.distribution = .fillProportionally
        firstRowStackView.isLayoutMarginsRelativeArrangement = true
        firstRowStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
       
        let radioButton1 = CardPartRadioButton()
        radioButton1.outerCircleColor = UIColor.systemRed
        radioButton1.outerCircleLineWidth = 2.0
        radioButton1.tag = 1
        radioButton1.isSelected = false
        radioButton1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        firstLabel.textColor = UIColor.systemRed
        firstLabel.text = "Not Selected"
        
        [radioButton1, firstLabel].forEach { component in
            firstRowStackView.addArrangedSubview(component)
        }
        
        let radioButton1Status = BehaviorRelay.init(value: radioButton1.isSelected)
        radioButton1.rx.tap.subscribe(onNext: {
            radioButton1Status.accept(!radioButton1Status.value)
            radioButton1.isSelected = radioButton1Status.value
            self.firstLabel.text = radioButton1Status.value ? "Selected" : "Not Selected"
        }).disposed(by: bag)
        
        secondRowStackView.axis = .horizontal
        secondRowStackView.spacing = 8
        secondRowStackView.distribution = .fillProportionally
        secondRowStackView.isLayoutMarginsRelativeArrangement = true
        secondRowStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let radioButton2 = CardPartRadioButton()
        radioButton2.outerCircleColor = UIColor.systemOrange
        radioButton2.outerCircleLineWidth = 2.0
        radioButton2.tag = 2
        radioButton2.isSelected = true
        radioButton2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton2.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
        secondLabel.textColor = UIColor.systemOrange
        secondLabel.text = "Selected"
        
        [radioButton2, secondLabel].forEach { component in
              secondRowStackView.addArrangedSubview(component)
        }
        
        setupCardParts([firstRowStackView, secondRowStackView])
        
        let radioButton2Status = BehaviorRelay.init(value: radioButton2.isSelected)
        radioButton2.rx.tap.subscribe(onNext: {
            radioButton2Status.accept(!radioButton2Status.value)
            radioButton2.isSelected = radioButton2Status.value
            self.secondLabel.text = radioButton2Status.value ? "Selected" : "Not Selected"
        }).disposed(by: bag)
    }
}
