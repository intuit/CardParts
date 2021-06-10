//
//  CardPartBarView.swift
//  Gala
//
//  Created by Urs, Bharath on 3/29/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

#if SWIFT_PACKAGE
import UIKit
#else
import Foundation
#endif

import RxSwift
import RxCocoa

public class CardPartBarView: UIView, CardPartView {
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    public var cornerRadius: CGFloat? = CardParts.theme.barCornerRadius
    public var backgroundLayer: CALayer!
    public var barLayer: CALayer!
    public var verticalLine: CALayer!

    
    public init() {
        super.init(frame: CGRect.zero)
        
        backgroundLayer = CALayer()
        backgroundLayer.anchorPoint = .zero
        backgroundLayer.backgroundColor = CardParts.theme.barBackgroundColor.cgColor
        
        barLayer = CALayer()
        barLayer.anchorPoint = .zero
        
        verticalLine = CALayer()
        verticalLine.anchorPoint = .zero
        verticalLine.backgroundColor = CardParts.theme.todayLineColor.cgColor

        self.layer.addSublayer(backgroundLayer)
        self.layer.addSublayer(barLayer)
        
        if CardParts.theme.showTodayLine {
            self.layer.addSublayer(verticalLine)
        }
    }
    
    /**
     The value of percent has to be between 0 and 1.
     If percent is 0.3, the bar will be filled 30% of its width.
     */
    public var percent: Double = 0.0 {
        didSet {
            if percent.isNaN {
                percent = 0
            }
            if percent.isInfinite {
                percent = 0
            }
            updateBarLayer()
        }
    }
    
    public var barHeight: CGFloat? = CardParts.theme.barHeight {
        didSet {
            updateBarLayer()
        }
    }
    
    public var barColor: UIColor = CardParts.theme.barColor {
        didSet {
            updateBarLayer()
        }
    }
    
    override public func layoutSubviews() {
        updateBarLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 18.0)
    }
    
    fileprivate func updateBarLayer() {
        
        let desiredHeight = self.barHeight ?? CGFloat(0.75 * self.bounds.height)
        
        let bounds = CGRect(x: 0, y: 0, width: CGFloat(percent) * self.bounds.width , height: desiredHeight)
        barLayer.bounds = bounds
        barLayer.backgroundColor = barColor.cgColor
        if CardParts.theme.roundedCorners {
            if let desiredCornerRadius: CGFloat = cornerRadius {
                barLayer.cornerRadius = desiredCornerRadius
                backgroundLayer.cornerRadius = desiredCornerRadius
            } else {
                barLayer.cornerRadius = bounds.height / 2
                backgroundLayer.cornerRadius = bounds.height / 2
            }
        }
        
        let backgroundBounds = CGRect(x: 0, y: 0, width: self.bounds.width , height: desiredHeight)
        backgroundLayer.bounds = backgroundBounds
        
        if CardParts.theme.showTodayLine {
            let verticalLineBounds = CGRect(x: 0, y: 0, width: 1.0 , height: self.bounds.height)
            verticalLine.bounds = verticalLineBounds
            
            let numberOfDivisions = self.bounds.width / CGFloat(Date().numberOfDaysThisMonth)
            let today = CGFloat(Date().day)
            verticalLine.position = CGPoint(x: today * numberOfDivisions, y: 0)
        }
    }
}

extension Reactive where Base: CardPartBarView {
    
    /**
     The value of percent has to be between 0 and 1.
     If percent is 0.3, the bar will be filled 30% of its width.
     */
    public var percent: Binder<Double>{
        return Binder(self.base) { (barView, percent) -> () in
            barView.percent = percent
        }
    }
    
    public var barColor: Binder<UIColor>{
        return Binder(self.base) { (barView, barColor) -> () in
            barView.barColor = barColor
        }
    }
}
