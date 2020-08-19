//
//  CardPartRadioButton.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 10/23/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class CardPartRadioButton: UIButton, CardPartView  {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    var outerCircleLayer = CAShapeLayer()
    var innerCircleLayer = CAShapeLayer()
    
    public var outerCircleColor:UIColor = .SystemBlue {
        didSet{
            outerCircleLayer.strokeColor = outerCircleColor.cgColor(with: traitCollection)
        }
    }
    
    public var innerCircleColor:UIColor = .SystemBlue {
        didSet {
            setFillState()
        }
    }
    
    public var outerCircleLineWidth:CGFloat = 3.0 {
        didSet {
            setCircleLayouts()
        }
    }
    
    public var innerCircleGap:CGFloat = 3.0  {
        didSet {
            setCircleLayouts()
        }
    }
    
    override public var isSelected :Bool {
        didSet {
            setFillState()
        }
    }
    
    public var circleRadius: CGFloat {
        let width = bounds.width
        let height = bounds.height
        
        let length = width > height ? height : width
        return (length - outerCircleLineWidth) / 2
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleLineWidth
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = outerCircleColor.cgColor
        layer.addSublayer(outerCircleLayer)
        
        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = outerCircleLineWidth
        innerCircleLayer.fillColor = UIColor.clear.cgColor
        innerCircleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(innerCircleLayer)
        
        setCircleLayouts()
        setFillState()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setCircleLayouts()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        outerCircleLayer.strokeColor = outerCircleColor.cgColor(with: traitCollection)
        setFillState()
    }

    /// fills the color inside the button based the selected state.
    private func setFillState() {
        innerCircleLayer.fillColor = self.isSelected ? outerCircleColor.cgColor(with: traitCollection) : UIColor.clear.cgColor
    }
    
    /// configures outer/inner circle frame,line widt and path
    private func setCircleLayouts() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleLineWidth
        outerCircleLayer.path = circlePath.cgPath
        
        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = outerCircleLineWidth
        innerCircleLayer.path = fillCirclePath.cgPath
    }
}

// MARK: - Methods for calculating circular frames , paths etc..
extension CardPartRadioButton {
    
    /// returns circular path
    private var circlePath: UIBezierPath {
        return UIBezierPath(roundedRect: setCircleFrame, cornerRadius: circleRadius)
    }
    
    /// calculates gap between inner and outer circle.
    private var fillCirclePath: UIBezierPath {
        let trueGap = innerCircleGap + (outerCircleLineWidth / 2)
        return UIBezierPath(roundedRect: setCircleFrame.insetBy(dx: trueGap, dy: trueGap), cornerRadius: circleRadius)
    }
    
    /// calculates circular frame for the button.
    private var setCircleFrame: CGRect {
        let width = bounds.width
        let height = bounds.height
        let (x, y) = width > height ? ((width / 2) - circleRadius , outerCircleLineWidth / 2) : (outerCircleLineWidth / 2 ,(height / 2) - circleRadius)
        let diameter = 2 * circleRadius
        return CGRect(x: x, y: y, width: diameter, height: diameter)
    }
}

extension Reactive where Base : CardPartRadioButton {
    
    public var radioButtonValue: Binder<Bool>{
        return Binder(self.base) { (button, status) -> () in
            button.isSelected = status
        }
    }
}
