//
//  Thing1CardController.swift
//  Gala
//
//  Created by Kier, Tom on 5/14/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import UIKit
import CardParts
import RxSwift
import RxCocoa

class Thing1CardController : CardPartsViewController  {
	
	var titlePart = CardPartTitleView(type: .titleWithMenu)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        titlePart.menuButtonImage = UIImage(named: "budgets_disclosure_icon", in: Bundle(for: CardPartTitleView.self), compatibleWith: nil)
		titlePart.title = "Thing 1"
        titlePart.menuTitle = "Hide this offer"
        titlePart.menuOptions = ["Hide"]
        titlePart.menuOptionObserver  = { (title, index) in
            print("hello")
        }

		setupCardParts([titlePart])
	}
}
