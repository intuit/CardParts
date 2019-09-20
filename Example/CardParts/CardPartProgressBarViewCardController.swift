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
    
    let barColors: [UIColor] = [UIColor.red,
                                UIColor.green,
                                UIColor.yellow,
                                UIColor.purple,
                                UIColor.blue]
    
    let barValues: [Double] = [300, 600, 650, 700, 750, 850]
    
    override func viewDidLoad() {
        let progressBarView = CardPartProgressBarView(barValues: barValues, barColors: barColors, marker: nil, markerLabelTitle: "", currentValue: Double(600), showShowBarValues: false)
        progressBarView.barCornerRadius = 4.0
        
        viewModel.currentValue.asObservable().bind(to: progressBarView.rx.currentValue).disposed(by: bag)
        
        setupCardParts([progressBarView])
        
        invalidateLayout(onChanges: [viewModel.currentValue])
    }
}


class ReactiveCardPartProgressBarViewModel {
    
    var currentValue = BehaviorRelay(value: Double(100))

    init() {
        randomise()
    }
    
    func randomise() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.random), userInfo: nil, repeats: true)
    }
    
    @objc func random() {
        switch arc4random() % 3 {
        case 0:
            currentValue.accept(200)
        case 1:
            currentValue.accept(400)
        case 2:
            currentValue.accept(600)
            
        default:
            return
        }
    }
    
}
