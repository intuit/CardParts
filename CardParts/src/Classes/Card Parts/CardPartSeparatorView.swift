//
//  CardPartSeparatorView.swift
//  Gala
//
//  Created by Kier, Tom on 2/13/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class CardPartSeparatorView : UIView, CardPartView {
	
	public var margins: UIEdgeInsets = CardParts.theme.horizontalSeparatorMargins
	
	public init() {
		
		super.init(frame: CGRect.zero)
		
		backgroundColor = CardParts.theme.separatorColor
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: 0.5)
	}
	
}
