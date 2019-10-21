//
//  CardPartView.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/17/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit

/// CardPartView protocol
public protocol CardPartView {
	
    /// margins
	var margins: UIEdgeInsets { get set }
    
    /// view
    var view : UIView! { get }
	
    /// viewController
	var viewController: UIViewController? { get }
}

extension CardPartView {
    
    /// Return self as? UIView by default
    public var view: UIView! {
        get {
            return self as? UIView
        }
    }

    /// Return nil by default
	public var viewController: UIViewController? {
		get {
			return nil
		}
	}
}

