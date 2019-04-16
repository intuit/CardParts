//
//  AnotherCardController.swift
//  Gala
//
//  Created by Kier, Tom on 5/14/17.
//  Copyright © 2018 Intuit. All rights reserved.
//

import UIKit
import CardParts
import RxSwift
import RxCocoa

class ReactiveCardViewModel {
	
    var text = BehaviorRelay(value: "")
	
	init() {
		startRandomText()
	}
	
	func startRandomText() {
		Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.randomText), userInfo: nil, repeats: true)
	}

	@objc func randomText() {
		switch arc4random() % 3 {
		case 0:
            text.accept("short text")
		case 1:
			text.accept("this is some long text that should wrap the line. Do this work?")
		case 2:
			text.accept("this is some very very very very very very very very very very very very very very very long text that should wrap the line. Does this work?")
		default:
			return
		}
	}

}

class ReactiveCardController : CardPartsViewController {
	
	var isHidden = BehaviorRelay(value: false)
	
	var viewModel = ReactiveCardViewModel()
	
	var titlePart = CardPartTitleView(type: .titleOnly)
	var textPart = CardPartTextView(type: .normal)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titlePart.title = "Another Card"
		
		viewModel.text.asObservable().bind(to: textPart.rx.text).disposed(by: bag)
		
		setupCardParts([titlePart, textPart])
		
        invalidateLayout(onChanges: [viewModel.text])
	}
	
}
