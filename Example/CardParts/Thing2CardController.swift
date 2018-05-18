//
//  Thing2CardController.swift
//  Gala
//
//  Created by Kier, Tom on 5/14/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import UIKit
import CardParts
import RxSwift
import RxCocoa

class Thing2CardController : CardPartsViewController  {
	
	var titlePart = CardPartTitleView(type: .titleOnly)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titlePart.title = "Thing 2"
		
		setupCardParts([titlePart])
	}
}
