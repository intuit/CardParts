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

/// CardPartSeparatorView displays a separator line. There are no reactive properties define for CardPartSeparatorView.
/// Uses CardParts theme separatorColor for backgroundColor.
public class CardPartSeparatorView : UIView, CardPartView {
	
    /// CardParts theme margins by default
	public var margins: UIEdgeInsets = CardParts.theme.horizontalSeparatorMargins
	
    /// Initialize with backgroundColor set to CardParts theme separatorColor
	public init() {
		
		super.init(frame: CGRect.zero)
		
		backgroundColor = CardParts.theme.separatorColor
	}
	
    /// Required init
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    /// IntrinsicContentSize
	override public var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: 0.5)
	}
	
}
