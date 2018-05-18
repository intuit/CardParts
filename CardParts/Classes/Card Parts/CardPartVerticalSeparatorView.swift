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

public class CardPartVerticalSeparatorView : UIView, CardPartView {
	
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
	public init() {
		
		super.init(frame: CGRect.zero)
		
		backgroundColor = CardParts.theme.separatorColor
		
		let separatorWidthConstraint = NSLayoutConstraint(item: self,attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0.5);
		
		self.addConstraint(separatorWidthConstraint)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
