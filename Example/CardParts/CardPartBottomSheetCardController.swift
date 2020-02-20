//
//  CardPartBottomSheetCardController.swift
//  CardParts_Example
//
//  Created by Ryan Cole on 2/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CardParts
import RxSwift

class CardPartBottomSheetCardController: CardPartsViewController {
    
    lazy var cardPartButtonView: CardPartButtonView = {
        let button = CardPartButtonView()
        button.setTitle("Tap to show bottom sheet", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let bottomSheetVC = CardPartsBottomSheetViewController()
    let bottomSheetContentVC = BottomSheetContentViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartButtonView.rx.tap.bind {
            print("tapped button")
            self.bottomSheetVC.contentVC = self.bottomSheetContentVC
            self.bottomSheetVC.presentBottomSheet()
        }.disposed(by: bag)
        
        setupCardParts([cardPartButtonView])
    }
}

class BottomSheetContentViewController: CardPartsViewController {
    lazy var cardPartTextView: CardPartTextView = {
        let text = CardPartTextView(type: .normal)
        text.text = "Bottom sheet!"
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCardParts([cardPartTextView])
    }
}
