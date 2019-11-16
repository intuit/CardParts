//
//  CardPartsFullScreenViewController.swift
//  Gala
//
//  Created by Kier, Tom on 7/17/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import Foundation

///This will make the card a full screen view controller. So if you do not want to build with an array of Cards, instead you can make a singular card full-screen.
///```
///class TestCardController: CardPartsFullScreenViewController  {
///    ...
///}
///```
open class CardPartsFullScreenViewController: CardPartsViewController {
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
	}

}
