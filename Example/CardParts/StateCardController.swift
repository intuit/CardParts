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
		
		setupCardParts([textPart])

        let spacerPart = CardPartSpacerView(height: 200)
        
        setupCardParts([textPart], forState: .empty)
        setupCardParts([spacerPart], forState: .hasData)
        
	}
	
	@objc func toggleHidden() {
        if state == .empty {
            state = .hasData
        } else {
            state = .empty
        }
	}
}
