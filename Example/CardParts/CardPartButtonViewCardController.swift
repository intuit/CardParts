//
//  CardPartButtonViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartButtonViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let cardPartButtonView = CardPartButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartButtonView"
        
        cardPartButtonView.setTitle("I'm a button!", for: .normal)
        cardPartButtonView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setupCardParts([cardPartTextView, cardPartButtonView])
    }
    
    @objc func buttonTapped() {
        
        let alertController = UIAlertController(title: "Woohoo!", message: "Isn't that awesome!?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
