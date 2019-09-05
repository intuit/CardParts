//
//  CardPartConfettiViewCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 9/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts


class CardPartConfettiViewCardController: CardPartsViewController {
    
    override func viewDidLoad() {
        
        let stackView = CardPartStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.margins = UIEdgeInsets(top: 10, left: 80, bottom: 0, right: 80)
        
        let mixedConfetti = CardPartButtonView()
        mixedConfetti.setTitle("Mixed Confetti", for: UIControl.State.normal)
        
        let diamond = CardPartButtonView()
        diamond.setTitle("Diamond Confetti", for: UIControl.State.normal)
        
        stackView.addArrangedSubview(mixedConfetti)
        stackView.addArrangedSubview(diamond)
        
        let listOfImages = [
                  UIImage(named: "circle"),
                  UIImage(named: "semiCircle") ,
                  UIImage(named: "rectangle"),
                  UIImage(named: "square"),
                  UIImage(named: "squiggle"),
                  UIImage(named: "star"),
                  UIImage(named: "filledCircle")
            ] as? [UIImage]
        
        let colors: [UIColor] = [ UIColor.flushOrange , UIColor.eggBlue , UIColor.blushPink , UIColor.cerulean , UIColor.limeGreen , UIColor.yellowSea , UIColor.superNova]
        
        guard let images = listOfImages else { return }
        
       let _ =  mixedConfetti.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let confettiView = CardPartConfettiView(frame: CGRect(x: 0, y: 150, width: self.view.bounds.width, height: self.view.bounds.height))
            confettiView.type  = .mixed
            confettiView.confettiImages = images
            confettiView.colors = colors
            confettiView.shape = CAEmitterLayerEmitterShape.line
            confettiView.beginConfetti()
            self.view.addSubview(confettiView)
        
           //change to desired number of seconds (in this case 10 seconds)
            let when = DispatchTime.now() + 10
            DispatchQueue.main.asyncAfter(deadline: when){
                confettiView.endConfetti()
            }
        }
        
        let _ =  diamond.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let confettiView = CardPartConfettiView()
            confettiView.type  = .diamond
            confettiView.shape = CAEmitterLayerEmitterShape.line
            confettiView.beginConfetti()
            self.view.addSubview(confettiView)
            
            // change to desired number of seconds (in this case 10 seconds)
            let when = DispatchTime.now() + 10
            DispatchQueue.main.asyncAfter(deadline: when){
                confettiView.endConfetti()
            }
        }
        
        setupCardParts([stackView])
    }
}
