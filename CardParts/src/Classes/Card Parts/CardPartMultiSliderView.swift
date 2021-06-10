//
//  CardPartMultiSliderView.swift
//  CardParts
//
//  Created by bcarreon1  on 1/30/20.
//

#if SWIFT_PACKAGE
import UIKit
#else
import Foundation
#endif

import RxSwift
import RxCocoa

public class CardPartMultiSliderView : CardPartMultiSlider, CardPartView {
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
}
