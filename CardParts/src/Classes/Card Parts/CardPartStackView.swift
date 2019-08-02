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
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
