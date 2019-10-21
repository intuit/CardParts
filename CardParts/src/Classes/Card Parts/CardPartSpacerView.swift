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

/// Allows you to add a space between card parts in case you need a space larger than the default margin. Initialize it with a specific height:
///```
///CardPartSpacerView(height: 30)
///```
public class CardPartSpacerView : UIView, CardPartView {
	
    /// .Zero by default
    public var margins: UIEdgeInsets = UIEdgeInsets.zero

	private var height: CGFloat
	
    /// Initiailzes with `height`
    ///
    /// - Parameter height: CGFloat
	public init(height: CGFloat) {
		
		self.height = height
		
		super.init(frame: CGRect.zero)
		
		backgroundColor = UIColor.clear
	}
	
    /// Required init
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    /// IntrinsicContentSize
	override public var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: height)
	}
	
}
