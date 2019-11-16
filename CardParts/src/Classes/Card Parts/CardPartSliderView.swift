//
//  CardPartSliderView.swift
//  CardParts
//
//  Created by Kier, Tom on 12/9/17.
//

import Foundation
import RxSwift
import RxCocoa

/// You can set min and max value as well as bind to the current set amount:
///```
///let slider = CardPartSliderView()
///slider.minimumValue = sliderViewModel.min
///slider.maximumValue = sliderViewModel.max
///slider.value = sliderViewModel.defaultAmount
///slider.rx.value.asObservable().bind(to: sliderViewModel.amount).disposed(by: bag)
///```
/// <h3>Reactive Properties</h3>
///```
///minimumValue: Float
///maximumValue: Float
///```
public class CardPartSliderView : UISlider, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
}

extension Reactive where Base: CardPartSliderView {
    
    /// Updates sliderView's minimumValue
    public var minimumValue: Binder<Float> {
        return Binder(self.base) { (sliderView, minimumValue) -> () in
            sliderView.minimumValue = minimumValue
        }
    }
    
    /// Updates sliderView's maximumValue
    public var maximumValue: Binder<Float> {
        return Binder(self.base) { (sliderView, maximumValue) -> () in
            sliderView.maximumValue = maximumValue
        }
    }
}
