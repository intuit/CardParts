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

public protocol CardController : NSObjectProtocol {
    
	func viewController() -> UIViewController
}


public protocol NoTopBottomMarginsCardTrait {
	
	func requiresNoTopBottomMargins() -> Bool
}

extension NoTopBottomMarginsCardTrait {
	
	public func requiresNoTopBottomMargins() -> Bool {
		return true
	}
}


public protocol TransparentCardTrait {
	
	func requiresTransparentCard() -> Bool
}

extension TransparentCardTrait {
	
	public func requiresTransparentCard() -> Bool {
		return true
	}
}


public protocol EditableCardTrait {
	
	func isEditable() -> Bool
	
	func onEditButtonTap()
}

extension EditableCardTrait {
	
	public func isEditable() -> Bool {
		return true
	}
}

public protocol HiddenCardTrait {
	
	var isHidden: Variable<Bool> { get }
}

public protocol ShadowCardTrait {
    func shadowColor() -> CGColor
    func shadowRadius() -> CGFloat
    func shadowOpacity() -> Float
}

extension ShadowCardTrait {
    func shadowColor() -> CGColor {
        return UIColor.Gray2.cgColor
    }

    func shadowRadius() -> CGFloat {
        return 8.0
    }
    
    func shadowOpacity() -> Float {
        return 0.7
    }
}

public protocol RoundedCardTrait {
    func cornerRadius() -> CGFloat
}

extension RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 10.0
    }
}

public protocol GradientCardTrait {
    func gradientColors() -> [UIColor]
}
