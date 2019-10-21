//
//  CardPartVerticalSeparatorView.swift
//  Gala
//
//  Created by Peter Fong on 3/28/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// As the name describes, it shows a vertical separator view opposed to a horizontal one
///
/// `backgroundColor` is CardParts theme separatorColor by default
public class CardPartVerticalSeparatorView : UIView, CardPartView {
	
    /// CardParts theme cardPartMargins by default
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
    /// Instantiate CardPartVerticalSeparatorView with width constraint
	public init() {
		
		super.init(frame: CGRect.zero)
		
		backgroundColor = CardParts.theme.separatorColor
		
		let separatorWidthConstraint = NSLayoutConstraint(item: self,attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0.5);
		
		self.addConstraint(separatorWidthConstraint)
	}
	
    /// Required init
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
