//
//  CardPartTableViewCardPartsCell.swift
//  Mint.com
//
//  Created by Kier, Tom on 11/28/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import Foundation

open class CardPartTableViewCardPartsCell : UITableViewCell {
		
	private var rightTopConstraint: NSLayoutConstraint!
	private var leftTopConstraint: NSLayoutConstraint!
	private var constraintsAdded = false
	
	var stackView : UIStackView
	private var cardParts:[CardPartView] = []

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		
		stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .equalSpacing
		stackView.alignment = .leading
		stackView.spacing = 0

		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
		
		for subview in contentView.subviews {
			subview.removeFromSuperview()
		}
		contentView.addSubview(stackView)
        
		setNeedsUpdateConstraints()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    open override func updateConstraints() {
		
		if !constraintsAdded {
			setupContraints()
		}
		
		super.updateConstraints()
	}
	
	func setupContraints() {
		
		constraintsAdded = true
		
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics: nil, views: ["stackView" : stackView]))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: ["stackView" : stackView]))
	}
	
	public func setupCardParts(_ cardParts:[CardPartView]) {
		
		self.cardParts = cardParts
		
		for cardPart in cardParts {
			
			if cardPart.margins.top > 0  {
				let spacer = CardPartSpacerView(height: cardPart.margins.top)
				stackView.addArrangedSubview(spacer)
				stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[spacer]|", options: [], metrics: nil, views: ["spacer" : spacer]))
			}
			
			if let _ = cardPart.viewController {
				// TODO add support for cardParts implemented as view controllers
				print("Viewcontroller card parts not supported in table view cells")
			} else {
				stackView.addArrangedSubview(cardPart.view)
			}
			
			let metrics = ["leftMargin" : cardPart.margins.left - 28, "rightMargin" : cardPart.margins.right - 28]
            stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[cardPartView]-rightMargin-|", options: [], metrics: metrics, views: ["cardPartView" : cardPart.view!]))
			
			if cardPart.margins.bottom > 0 {
				let spacer = CardPartSpacerView(height: cardPart.margins.bottom)
				stackView.addArrangedSubview(spacer)
				stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[spacer]|", options: [], metrics: nil, views: ["spacer" : spacer]))
			}
			
		}
	}

}
