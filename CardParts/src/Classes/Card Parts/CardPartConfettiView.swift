//
//  CardPartConfettiView.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 9/3/19.
//

import Foundation
import UIKit
import QuartzCore

public enum ConfettiType {
    case diamond
    case star
    case mixed
    case image(UIImage)
}

public class CardPartConfettiView: UIView, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    public var colors:[UIColor] = [ UIColor.crusta , UIColor.goldenTainoi , UIColor.monteCarlo , UIColor.strikemaster ]
    public var type:ConfettiType = .diamond
    public var intensity:Float = 0.5
    public var shape:CAEmitterLayerEmitterShape = .sphere {
        didSet {
            emitter.emitterShape = shape
        }
    }
    public var confettiImages:[UIImage] = [UIImage(named: "confetti", in: Bundle(for: CardPartConfettiView.self),compatibleWith: nil)!]
    
    //A layer that emits, animates, and renders a particle system.
    var emitter: CAEmitterLayer = CAEmitterLayer()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startConfetti() {
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = shape
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        //construct the cells
        var cells = [CAEmitterCell]()
        for (index,color) in colors.enumerated() {
            cells.append(confettiWithColor(color: color , index: index))
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
    }
    
    func confettiWithColor(color: UIColor, index : Int) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        
        //The number of emitted objects created every second. Animatable.
        confetti.birthRate = 6.0 * intensity
        
        //The lifetime of the cell, in seconds.
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0.0
        
        confetti.color = color.cgColor
        
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        
        //The longitudinal orientation of the emission angle
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        
        //The rotational velocity, measured in radians per second, to apply to the cell.
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        
        //Specifies the range over which the scale value can vary
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        
        confetti.contents = imageForType(type: type , index: index)?.cgImage
       
        return confetti
    }
    
    func imageForType(type: ConfettiType, index: Int = 0) -> UIImage? {
        switch type {
        case .diamond:
            return UIImage(named: "diamond", in: Bundle(for: CardPartConfettiView.self), compatibleWith: nil)
        case .star:
            return UIImage(named: "Star1", in: Bundle(for: CardPartConfettiView.self), compatibleWith: nil)
        case let .image(customImage):
            return customImage
        case .mixed:
            guard let random = confettiImages.randomElement() else {
                return UIImage(named: "confetti", in: Bundle(for: CardPartConfettiView.self),compatibleWith: nil)
            }
            return random
        }
    }
}
