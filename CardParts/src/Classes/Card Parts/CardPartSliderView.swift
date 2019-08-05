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
}
