//
//  CardController.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/18/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// CardController protocol
public protocol CardController : NSObjectProtocol {
    
    /// Method to return UIViewController
	func viewController() -> UIViewController
}


/// No Top or Bottom Margins Card trait
public protocol NoTopBottomMarginsCardTrait {
	
    /// Determines if card should not have top and bottom margins
	func requiresNoTopBottomMargins() -> Bool
}

extension NoTopBottomMarginsCardTrait {
	
	public func requiresNoTopBottomMargins() -> Bool {
		return true
	}
}


/// Transparent Card trait
public protocol TransparentCardTrait {
	
    /// Determines if card should be transparent
	func requiresTransparentCard() -> Bool
}

extension TransparentCardTrait {
	
	public func requiresTransparentCard() -> Bool {
		return true
	}
}


/// Editable protocol
public protocol EditableCardTrait {
	
    /// Determine if Card is editable
	func isEditable() -> Bool
	
    /// Edit button implementation
	func onEditButtonTap()
}

extension EditableCardTrait {
	
    /// Default isEditable implementation
    ///
    /// - Returns: true
	public func isEditable() -> Bool {
		return true
	}
}

/// Hidden Card trait
public protocol HiddenCardTrait {
	
    /// isHidden reactive property
	var isHidden: BehaviorRelay<Bool> { get }
}

/// Shadow Card trait
public protocol ShadowCardTrait {
    /// Shadow color
    func shadowColor() -> CGColor
    /// Shadow radius
    func shadowRadius() -> CGFloat
    /// Shadow opacity
    func shadowOpacity() -> Float
    /// Shadow offset
    func shadowOffset() -> CGSize
}

extension ShadowCardTrait {
    /// Default shadowColor
    ///
    /// - Returns: Gray2
    func shadowColor() -> CGColor {
        return UIColor.Gray2.cgColor
    }

    /// Default shadowRadius
    ///
    /// - Returns: 8.0
    func shadowRadius() -> CGFloat {
        return 8.0
    }
    
    /// Default shadowOpacity
    ///
    /// - Returns: 0.7
    func shadowOpacity() -> Float {
        return 0.7
    }

    /// Default shadowOffset
    ///
    /// - Returns: width 0, height 5
    func shadowOffset() -> CGSize {
        return CGSize(width: 0, height: 5)
    }
}

/// Rounded Card trait
public protocol RoundedCardTrait {
    /// Corner Radius method
    func cornerRadius() -> CGFloat
}

extension RoundedCardTrait {
    /// Default cornerRadius
    ///
    /// - Returns: 10.0
    func cornerRadius() -> CGFloat {
        return 10.0
    }
}

/// Gradient Card trait
@objc public protocol GradientCardTrait {
    /// Gradient colors
    func gradientColors() -> [UIColor]
    /// Gradient angle
    @objc optional func gradientAngle() -> Float
}

/// Long Press Gesture delegate
@objc public protocol CardPartsLongPressGestureRecognizerDelegate: class {
    /// Long press gesture method
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) -> Void
    /// Duration for long press
    var minimumPressDuration: CFTimeInterval { get }
}
extension CardPartsLongPressGestureRecognizerDelegate {
    /// Default long press duration: 1.0
    var minimumPressDuration: CFTimeInterval { return 1.0 }
}

/// Border Trait protocol
public protocol BorderCardTrait {
    /// Width of border
    func borderWidth() -> CGFloat
    /// Color of border
    func borderColor() -> CGColor
}

extension BorderCardTrait {
    
    /// Default borderWith
    ///
    /// - Returns: 0.5
    func borderWidth() -> CGFloat {
        return 0.5
    }
    
    /// Default borderColor
    ///
    /// - Returns: Gray7
    func borderColor() -> CGColor {
        return UIColor.Gray7.cgColor
    }
}

