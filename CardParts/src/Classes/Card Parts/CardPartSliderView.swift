//
//  CardPartSliderView.swift
//  CardParts
//
//  Created by Kier, Tom on 12/9/17.
//

import Foundation
import RxSwift
import RxCocoa

public class CardPartSliderView : UISlider, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    public var height: CGFloat
    
    public init(height: CGFloat = 3.0) {
        self.height = height
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: self.height))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}

extension Reactive where Base: CardPartSliderView {
    
    public var minimumValue: Binder<Float> {
        return Binder(self.base) { (sliderView, minimumValue) -> () in
            sliderView.minimumValue = minimumValue
        }
    }
    
    public var maximumValue: Binder<Float> {
        return Binder(self.base) { (sliderView, maximumValue) -> () in
            sliderView.maximumValue = maximumValue
        }
    }
    
    public var minimumTrackTintColor: Binder<UIColor> {
        return Binder(self.base) { (sliderView, minimumTrackTintColor) -> () in
            sliderView.minimumTrackTintColor = minimumTrackTintColor
        }
    }
    
    public var maximumTrackTintColor: Binder<UIColor> {
        return Binder(self.base) { (sliderView, maximumTrackTintColor) -> () in
            sliderView.maximumTrackTintColor = maximumTrackTintColor
        }
    }
}
