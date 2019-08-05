//
//  CardPartStackView.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/22/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

public class CardPartStackView : UIStackView, CardPartView {
	
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    public var backgroundView:UIView = UIView()
    public var cornerRadius: CGFloat = 4.0
    
    public func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = cornerRadius
        
        stackView.insertSubview(view, at: 0)
        
        stackView.layout {
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
        }
    }
}
