//
//  CardPartView.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/17/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit

public protocol CardPartView {
	
	var margins: UIEdgeInsets { get set }
    
    var view : UIView! { get }
	
	var viewController: UIViewController? { get }
}

extension CardPartView {
    
    public var view: UIView! {
        get {
            return self as? UIView
        }
    }

	public var viewController: UIViewController? {
		get {
			return nil
		}
	}
}

