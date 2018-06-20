//
//  TestCardController.swift
//  Gala
//
//  Created by Kier, Tom on 3/8/17.
//  Copyright © 2018 Intuit. All rights reserved.
//

import UIKit
import CardParts
import RxSwift
import RxCocoa

extension CardState {
    static let customState = "customState"
}

class StateCardController : CardPartsViewController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		startRandomHides()
	}
	
	func startRandomHides() {
		Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.toggleHidden), userInfo: nil, repeats: true)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

        self.state = CardState.empty

        let textPart = CardPartTextView(type: .normal)
		textPart.text = "This is the default empty state!"
		
		setupCardParts([textPart])

        let spacerPart = CardPartSpacerView(height: 200)
        
        let customTextPart = CardPartTextView(type: .normal)
        customTextPart.text = "This is a custom state called 'customState'!"
        
        setupCardParts([textPart], forState: CardState.empty)
        setupCardParts([spacerPart], forState: CardState.hasData)
        setupCardParts([customTextPart], forState: CardState.customState)
	}
	
	@objc func toggleHidden() {
        if state == CardState.empty {
            state = CardState.hasData
        }
        else if state == CardState.hasData {
            state = CardState.customState
        }
        else {
            state = CardState.empty
        }
	}
}
