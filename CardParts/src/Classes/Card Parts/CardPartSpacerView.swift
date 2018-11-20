//
//  CardPartSpacerView.swift
//  Gala
//
//  Created by Kier, Tom on 2/21/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class CardPartSpacerView : UIView, CardPartView {
	
    public var margins: UIEdgeInsets = UIEdgeInsets.zero

	private var height: CGFloat
	
	public init(height: CGFloat) {
		
		self.height = height
		
		super.init(frame: CGRect.zero)
		
		backgroundColor = UIColor.clear
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: height)
	}
	
}
