//
//  CardPartStackView.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/22/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

///CardPartStackView displays a UIStackView that can contain other card parts, and even other CardPartStackViews. Using CardPartStackView allows for creating custom layouts of card parts. By nesting CardPartStackViews you can create almost any layout.
///
///To add a card part to the stack view call its `addArrangedSubview` method, specifying the card part's view property as the view to be added to the stack view. For example:
///```
///horizStackPart.addArrangedSubview(imagePart)
///```
///Also, provides an option to round the corners of the stackview
///```
///let roundedStackView = CardPartStackView()
///roundedStackView.cornerRadius = 10.0
///roundedStackView.pinBackground(roundedStackView.backgroundView, to: roundedStackView)
///roundedStackView
///```
/// ![StackView Example](https://raw.githubusercontent.com/Intuit/CardParts/master/images/roundedStackView.png)
///
///There are no reactive properties defined for CardPartStackView. However you can use the default UIStackView properties (distribution, alignment, spacing, and axis) to configure the stack view.
public class CardPartStackView : UIStackView, CardPartView {
	
    /// CardParts theme margins by default
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    /// backgroundView
    public var backgroundView:UIView = UIView()
    /// 4.0 by default
    public var cornerRadius: CGFloat = 4.0
    
    /// Pins background to leading, trailing, top, bottom
    public func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = cornerRadius
        
        stackView.insertSubview(view, at: 0)
        
        stackView.layout {
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
        }
    }
}
