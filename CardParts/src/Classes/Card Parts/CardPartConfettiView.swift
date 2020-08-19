//
//  CardPartConfettiView.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 9/3/19.
//

import Foundation
import UIKit
import QuartzCore

/// Enum which tells which type of confetti partciles to choose.
///
/// - diamond: displays diamond shaped particles
/// - confetti: displays arc symbol shaped particles
/// - star: displays star shaped particles
/// - mixed: provides a way to mix and macth multiple images as confetti particles.
/// - image: provides option of displaying custom image as confetti particles.
public enum ConfettiType {
    case confetti
    case diamond
    case star
    case mixed
    case image(UIImage)
}

public class CardPartConfettiView: UIView, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    public var colors:[UIColor] = [ UIColor.SystemRed, UIColor.SystemGreen, UIColor.SystemBlue ]
    public var type:ConfettiType = .star
    /// default : 0.5 value ranges from 0 - 1(being very slow)
    public var intensity:Float = 0.5
    public var shape:CAEmitterLayerEmitterShape = .sphere {
        didSet {
            emitter.emitterShape = shape
        }
    }
    
    public var confettiImages = [UIImage(named: "confetti", in: Bundle(for: CardPartConfettiView.self),compatibleWith: nil)] as? [UIImage]
    
    //A layer that emits, animates, and renders a particle system.
    var emitter: CAEmitterLayer = CAEmitterLayer()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// constructs and configures emitter shape and add colors to the emitter particles.
    public func beginConfetti() {
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = shape
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        //construct the cells
        var cells = [CAEmitterCell]()
        for (index,color) in colors.enumerated() {
            let colorConfetti = confetti(with: color, for: index)
            cells.append(colorConfetti)
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
    }
    
    /// stops displaying confetti particles.
    public func endConfetti() {
        emitter.birthRate = 0
    }
    
    /// Provides a single particle with
    ///          1.specified color for particular index
    ///          2.configurable velocity ranges.
    ///          3.angle of orientation to emit the partcicles.
    ///          4.spin ratio & it's range, certain particles needs to rotate
    ///          5.scale of particles.
    ///
    /// - Parameters:
    ///   - color: color which will be applied to confetti
    ///   - index: index of the confetti
    /// - Returns: confetti particle
    private func confetti(with color: UIColor, for index : Int) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        
        //The number of emitted objects created every second. Animatable.
        confetti.birthRate = 6.0 * intensity
        
        //The lifetime of the cell, in seconds.
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0.0
        
        //set color
        confetti.color = color.cgColor
        
        //set velocity ranges
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
        
        //set images for confetti content.
        confetti.contents = image(for: type, index: index)?.cgImage
       
        return confetti
    }
    
    /// retuns the image based on the type of confetti
    ///
    /// - Parameters:
    ///   - type: confetti type
    ///   - index:position for image to return
    /// - Returns: UImage based on confeeti type and index position
    private func image(for type: ConfettiType, index: Int = 0) -> UIImage? {
        switch type {
        case .diamond:
            return UIImage(named: "diamond", in: Bundle(for: CardPartConfettiView.self), compatibleWith: nil)
        case .star:
            return UIImage(named: "star", in: Bundle(for: CardPartConfettiView.self), compatibleWith: nil)
        case let .image(customImage):
            return customImage
        case .mixed:
            return confettiImages?[index]
        case .confetti:
             return UIImage(named: "confetti", in: Bundle(for: CardPartConfettiView.self), compatibleWith: nil)
        }
    }
}
