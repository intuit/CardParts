//
//  ConfettiViewController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 9/4/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class ConfettiViewController: CardsViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let confettiView = CardPartConfettiView(frame: self.view.bounds)
        confettiView.type  = .mixed
        confettiView.confettiImages = [ UIImage(named: "themeIcon"), UIImage(named: "cardIcon") ] as! [UIImage]
        confettiView.shape = CAEmitterLayerEmitterShape.line
        confettiView.startConfetti()
       
        
        self.view.addSubview(confettiView)
    }
}
