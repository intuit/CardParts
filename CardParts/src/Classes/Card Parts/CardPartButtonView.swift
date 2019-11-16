//
//  CardPartButtonView.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/22/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa


/// CardPartButtonView displays a single button.
///
/// CardPartButtonView exposes the following reactive properties that can be bound to view model properties:
///
/// ```
/// var buttonTitle: String?
/// var isSelected: Bool?
/// var isHighlighted: Bool?
/// var contentHorizontalAlignment: UIControlContentHorizontalAlignment
/// var alpha: CGFloat
/// var backgroundColor: UIColor?
/// var isHidden: Bool
/// var isUserInteractionEnabled: Bool
/// var tintColor: UIColor?
///```
public class CardPartButtonView : UIButton, CardPartView {
	
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins

    /// Initializes button view setting up titleLabel, titleColor and cornerRadius
    public init() {
		
		super.init(frame: CGRect.zero)
		
		titleLabel?.isOpaque = true
        titleLabel?.font = CardParts.theme.buttonTitleFont
        titleLabel?.backgroundColor = UIColor.clear
		backgroundColor = UIColor.clear
        setTitleColor(CardParts.theme.buttonTitleColor, for: .normal)
		setTitleColor(CardParts.theme.buttonTitleColor.withAlphaComponent(0.3), for: .highlighted)
		contentHorizontalAlignment = .left
		layer.cornerRadius = CardParts.theme.buttonCornerRadius
	}
    
    /// Required init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
}

extension Reactive where Base: CardPartButtonView {
    
    /// Updates buttonView's title
	public var buttonTitle: Binder<String>{
		return Binder(self.base) { (buttonView, title) -> () in
			buttonView.setTitle(title, for: .normal)
		}
	}

    /// Updates buttonView's content horizontal alignment
	public var contentHorizontalAlignment: Binder<UIControl.ContentHorizontalAlignment>{
		return Binder(self.base) { (buttonView, contentHorizontalAlignment) -> () in
			buttonView.contentHorizontalAlignment = contentHorizontalAlignment
		}
	}

}

