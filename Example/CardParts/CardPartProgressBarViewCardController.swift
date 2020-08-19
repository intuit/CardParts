//
//  CardPartProgressBarViewCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 9/19/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts
import RxCocoa
import RxSwift

class CardPartProgressBarViewCardController: CardPartsViewController {
    
    var viewModel = ReactiveCardPartProgressBarViewModel()
    
    let barColors: [UIColor] = [UIColor.systemRed,
                                UIColor.systemGreen,
                                UIColor.systemYellow,
                                UIColor.systemPurple,
                                UIColor.systemBlue]
    
    override func viewDidLoad() {
        let progressBarView = CardPartProgressBarView(barColors: barColors, marker: nil, markerLabelTitle: "", currentValue: 2, showShowBarValues: false)
        progressBarView.barCornerRadius = 4.0
        progressBarView.margins = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 70)
        viewModel.currentValue.asObservable().bind(to: progressBarView.rx.currentValue).disposed(by: bag)
        
        setupCardParts([progressBarView])
        
        invalidateLayout(onChanges: [viewModel.currentValue])
    }
}


class ReactiveCardPartProgressBarViewModel {
    
    var currentValue = BehaviorRelay(value: Int(3))
    
    init() {
        randomise()
    }
    
    func randomise() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.random), userInfo: nil, repeats: true)
    }
    
    @objc func random() {
        switch arc4random() % 3 {
        case 0:
            currentValue.accept(1)
        case 1:
            currentValue.accept(2)
        case 2:
            currentValue.accept(3)
            
        default:
            return
        }
    }
    
}

