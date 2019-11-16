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

/// Provides the capability to add  radio buttons with configurable inner/outer circle line width , colors along with tap etc..
///
///```
///let radioButton = CardPartRadioButton()
///radioButton.outerCircleColor = UIColor.orange
///radioButton.outerCircleLineWidth = 2.0
///
///radioButton2.rx.tap.subscribe(onNext: {
///    print("Radio Button Tapped")
///}).disposed(by: bag)
///```
///![Radio Button Example](https://raw.githubusercontent.com/Intuit/CardParts/master/images/radioButtons.png)
public class CardPartRadioButton: UIButton, CardPartView  {
    
    /// Card Parts theme cardPartMargins by default
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    var outerCircleLayer = CAShapeLayer()
    var innerCircleLayer = CAShapeLayer()
    
    /// Outer circle color, `.blue` by default
    public var outerCircleColor:UIColor = .blue {
        didSet{
            outerCircleLayer.strokeColor = outerCircleColor.cgColor
        }
    }
    
    /// Inner circle color, `.blue` by default
    public var innerCircleColor:UIColor = .blue {
        didSet {
            setFillState()
        }
    }
    
    /// Outer circle line width, `3.0` by default
    public var outerCircleLineWidth:CGFloat = 3.0 {
        didSet {
            setCircleLayouts()
        }
    }
    
    /// Inner circle spacing, `3.0` by default
    public var innerCircleGap:CGFloat = 3.0  {
        didSet {
            setCircleLayouts()
        }
    }
    
    /// Selected state, triggers fillState
    override public var isSelected :Bool {
        didSet {
            setFillState()
        }
    }
    
    /// Circle radius, computation of smaller size minus outer line width
    public var circleRadius: CGFloat {
        let width = bounds.width
        let height = bounds.height
        
        let length = width > height ? height : width
        return (length - outerCircleLineWidth) / 2
    }
    
    /// Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// Required init
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
    
    /// Layout subviews
    override public func layoutSubviews() {
        super.layoutSubviews()
        setCircleLayouts()
    }

    /// fills the color inside the button based the selected state.
    private func setFillState() {
        innerCircleLayer.fillColor = self.isSelected ? outerCircleColor.cgColor : UIColor.clear.cgColor
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
    
    /// Button selected state
    public var radioButtonValue: Binder<Bool>{
        return Binder(self.base) { (button, status) -> () in
            button.isSelected = status
        }
    }
}
