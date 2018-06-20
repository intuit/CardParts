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

class StateCardController : CardPartsViewController {
	
    let customStateKey = "myCustomState"
    
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

        self.state = .empty

        let textPart = CardPartTextView(type: .normal)
		textPart.text = "Watch me change states!"

        let loadingCardPart = CardPartTextView(type: .normal)
        loadingCardPart.text = "I am a loading state"
        
        let customCardPart = CardPartTextView(type: .normal)
        customCardPart.text = "I am a custom state that you can make!"
        
        setupCardParts([textPart], forState: .empty)
        setupCardParts([loadingCardPart], forState: .loading)
        setupCardParts([customCardPart], forState: .custom(customStateKey))
	}
	
	@objc func toggleHidden() {
        if state == .empty {
            state = .loading
        } else if state == .loading {
            state = .custom(customStateKey)
        } else if state == .custom(customStateKey) {
            state = .empty
        }
	}
}
