//
//  CardPartPillLabelCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 8/2/19.
//  Copyright © 2019 Intuit. All rights reserved.
//

import Foundation
import CardParts
import RxSwift
import RxCocoa

class CardPartPillLabelCardController: CardPartsViewController {
    
    let stackView = CardPartStackView()
    let label1 = CardPartPillLabel()
    let label2 = CardPartPillLabel()
    let label3 = CardPartPillLabel()
    
    var viewModel = ReactiveCardPartPillViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = "Label1"
        label1.verticalPadding = 10
        label1.horizontalPadding = 10
        
        label2.text = "Label2"
        label2.verticalPadding = 10
        label2.horizontalPadding = 10
        
        label3.verticalPadding = 10
        label3.horizontalPadding = 10
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        [label1, label2, label3].forEach { label in
            if #available(iOS 13.0, *) {
                label.backgroundColor = .tertiarySystemFill
                label.textColor = .label
            } else {
                label.backgroundColor = UIColor.black
                label.textColor = UIColor.white
            }
            stackView.addArrangedSubview(label)
        }
        
        viewModel.labelText.asObservable().bind(to: label3.rx.labelText).disposed(by: bag)
        viewModel.verticalPadding.asObservable().bind(to: label3.rx.verticalPadding).disposed(by: bag)
        viewModel.horizontalPadding.asObservable().bind(to: label3.rx.horizontalPadding).disposed(by: bag)
        
        setupCardParts([stackView])
        
        invalidateLayout(onChanges: [viewModel.labelText])
        invalidateLayout(onChanges: [viewModel.verticalPadding, viewModel.horizontalPadding])
    }
}


class ReactiveCardPartPillViewModel {
    
    var labelText = BehaviorRelay(value: "Defaul Label")
    var verticalPadding = BehaviorRelay(value: CGFloat(1.0))
    var horizontalPadding = BehaviorRelay(value: CGFloat(1.0))
    
    init() {
        startRandomText()
    }
    
    func startRandomText() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.randomText), userInfo: nil, repeats: true)
    }
    
    @objc func randomText() {
        switch arc4random() % 3 {
        case 0:
            labelText.accept("Label4")
            verticalPadding.accept(6.0)
            horizontalPadding.accept(2.0)
        case 1:
            labelText.accept("Label5")
            verticalPadding.accept(8.0)
            horizontalPadding.accept(4.0)
        case 2:
            labelText.accept("Label6")
            verticalPadding.accept(14.0)
            horizontalPadding.accept(6.0)
            
        default:
            return
        }
    }
    
}
