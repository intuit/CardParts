//
//  CardPartTitleDescriptionView.swift
//  Gala
//
//  Created by Kier, Tom on 3/8/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum CardPartTitlePosition {
	case top
	case bottom
}

public enum CardPartTitleCompression {
	case left
	case right
}

public enum CardPartSecondaryTitleDescPosition {
    case center(amount: CGFloat)
    case right
}

public class CardPartTitleDescriptionView : UIView, CardPartView {
	
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
	public var leftTitleLabel: UILabel
	public var leftDescriptionLabel: UILabel
	public var rightTitleLabel: UILabel
	public var rightDescriptionLabel: UILabel
	
	public var leftTitleText: String? {
		didSet {
			leftTitleLabel.text = leftTitleText
		}
	}

	public var leftDescriptionText: String? {
		didSet {
			leftDescriptionLabel.text = leftDescriptionText
		}
	}
	
	public var leftDescriptionAttributedText: NSAttributedString? {
		didSet {
			leftDescriptionLabel.attributedText = leftDescriptionAttributedText
		}
	}
    
    public var leftTitleAttributedText: NSAttributedString? {
        didSet {
            leftTitleLabel.attributedText = leftTitleAttributedText
        }
    }
	
	public var rightTitleText: String? {
		didSet {
			rightTitleLabel.text = rightTitleText
		}
	}
	
	public var rightDescriptionText: String? {
		didSet {
			rightDescriptionLabel.text = rightDescriptionText
		}
	}
	
	public var rightDescriptionAttributedText: NSAttributedString? {
		didSet {
			rightDescriptionLabel.attributedText = rightDescriptionAttributedText
		}
	}
    
    public var rightTitleAttributedText: NSAttributedString? {
        didSet {
            rightTitleLabel.attributedText = rightTitleAttributedText
        }
    }
	
	public var leftTitleFont: UIFont = CardParts.theme.leftTitleFont {
		didSet {
			leftTitleLabel.font = leftTitleFont
		}
	}
	public var leftDescriptionFont: UIFont = CardParts.theme.leftDescriptionFont {
		didSet {
			leftDescriptionLabel.font = leftDescriptionFont
		}
	}
	public var rightTitleFont: UIFont = CardParts.theme.rightTitleFont {
		didSet {
			rightTitleLabel.font = rightTitleFont
		}
	}
	public var rightDescriptionFont: UIFont = CardParts.theme.rightDescriptionFont {
		didSet {
			rightDescriptionLabel.font = rightDescriptionFont
		}
	}
	
	public var leftTitleColor: UIColor = CardParts.theme.leftTitleColor {
		didSet {
			leftTitleLabel.textColor = leftTitleColor
		}
	}
	public var leftDescriptionColor: UIColor = CardParts.theme.leftDescriptionColor {
		didSet {
			leftDescriptionLabel.textColor = leftDescriptionColor
		}
	}
	public var rightTitleColor: UIColor = CardParts.theme.rightTitleColor {
		didSet {
			rightTitleLabel.textColor = rightTitleColor
		}
	}
	public var rightDescriptionColor: UIColor = CardParts.theme.rightDescriptionColor {
		didSet {
			rightDescriptionLabel.textColor = rightDescriptionColor
		}
	}
	
	public var titleCompression: CardPartTitleCompression = .right {
		didSet {
			setNeedsUpdateConstraints()
		}
	}

	private var rightTopConstraint: NSLayoutConstraint!
	private var leftTopConstraint: NSLayoutConstraint!
	private var constraintsAdded = false
	private var titlePos: CardPartTitlePosition
    private var secondaryPos: CardPartSecondaryTitleDescPosition

    public init(titlePosition: CardPartTitlePosition = .top, secondaryPosition:CardPartSecondaryTitleDescPosition = CardParts.theme.secondaryTitlePosition) {
		
		titlePos = titlePosition
        secondaryPos = secondaryPosition
		
		leftTitleLabel = UILabel(frame: CGRect.zero)
		leftTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		leftTitleLabel.font = leftTitleFont
		leftTitleLabel.textColor = leftTitleColor
		
		leftDescriptionLabel = UILabel(frame: CGRect.zero)
		leftDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		leftDescriptionLabel.numberOfLines = 0
		leftDescriptionLabel.lineBreakMode = .byWordWrapping
		leftDescriptionLabel.font = leftDescriptionFont
		leftDescriptionLabel.textColor = leftDescriptionColor
		
		rightTitleLabel = UILabel(frame: CGRect.zero)
		rightTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		rightTitleLabel.font = rightTitleFont
		rightTitleLabel.textColor = rightTitleColor
		
		rightDescriptionLabel = UILabel(frame: CGRect.zero)
		rightDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		rightDescriptionLabel.font = rightDescriptionFont
		rightDescriptionLabel.textColor = rightDescriptionColor
		
		super.init(frame: CGRect.zero)
		
		addSubview(leftTitleLabel)
		addSubview(leftDescriptionLabel)
		addSubview(rightTitleLabel)
		addSubview(rightDescriptionLabel)
		
		setNeedsUpdateConstraints()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func updateConstraints() {
		
		if !constraintsAdded {
			setupContraints()
		}
		
		if rightDescriptionLabel.text == nil || rightDescriptionLabel.text?.count == 0 {
			removeConstraint(rightTopConstraint)
			let constraint = NSLayoutConstraint(item: rightTitleLabel,
			                                    attribute: .centerY,
			                                    relatedBy: .equal,
			                                    toItem: self,
			                                    attribute: .centerY,
			                                    multiplier: 1.0,
			                                    constant: 0.0)
			addConstraint(constraint)
		}
		if leftDescriptionLabel.text == nil || leftDescriptionLabel.text?.count == 0 {
			removeConstraint(leftTopConstraint)
			let constraint = NSLayoutConstraint(item: leftTitleLabel,
			                                    attribute: .centerY,
			                                    relatedBy: .equal,
			                                    toItem: self,
			                                    attribute: .centerY,
			                                    multiplier: 1.0,
			                                    constant: 0.0)
			addConstraint(constraint)
		}
		
		if titleCompression == .right {
            leftTitleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
            rightTitleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
		} else {
            leftTitleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
            rightTitleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
		}
		
		super.updateConstraints()
	}
	
	func setupContraints() {
		
		constraintsAdded = true
		
		let topMargin: CGFloat = 12
		let leftMargin: CGFloat = 0
		let rightMargin: CGFloat = 0
		let verticalMarginBetweenTitleAndDescription: CGFloat = 2
		
		let leftTopView = titlePos == .top ? leftTitleLabel : leftDescriptionLabel
		let leftBottomView = titlePos == .top ? leftDescriptionLabel : leftTitleLabel
		let rightTopView = titlePos == .top ? rightTitleLabel : rightDescriptionLabel
		let rightBottomView = titlePos == .top ? rightDescriptionLabel : rightTitleLabel
		
		// Left Top View ////////////////////////////////////////////////////////////////////////////////
		// Top
        leftTopView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
		
		var constraint = NSLayoutConstraint(item: leftTopView,
		                                    attribute: .top,
		                                    relatedBy: .equal,
		                                    toItem: self,
		                                    attribute: .top,
		                                    multiplier: 1.0,
		                                    constant: topMargin)
		addConstraint(constraint)
		leftTopConstraint = constraint
		
		// Left
		constraint = NSLayoutConstraint(item: leftTopView,
		                                attribute: .left,
		                                relatedBy: .equal,
		                                toItem: self,
		                                attribute: .left,
		                                multiplier: 1.0,
		                                constant: leftMargin)
		addConstraint(constraint)
		
		// Left Bottom View ////////////////////////////////////////////////////////////////////////////////
		// Top
        leftBottomView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)

		constraint = NSLayoutConstraint(item: leftBottomView,
		                                attribute: .top,
		                                relatedBy: .equal,
		                                toItem: leftTopView,
		                                attribute: .bottom,
		                                multiplier: 1.0,
		                                constant: verticalMarginBetweenTitleAndDescription)
		addConstraint(constraint)

		// Bottom
		constraint = NSLayoutConstraint(item: leftBottomView,
		                                attribute: .bottom,
		                                relatedBy: .equal,
		                                toItem: self,
		                                attribute: .bottom,
		                                multiplier: 1.0,
		                                constant: -topMargin)
		addConstraint(constraint)

		// Left
		constraint = NSLayoutConstraint(item: leftBottomView,
		                                attribute: .left,
		                                relatedBy: .equal,
		                                toItem: self,
		                                attribute: .left,
		                                multiplier: 1.0,
		                                constant: leftMargin)
		addConstraint(constraint)
		
		// Right Top View ////////////////////////////////////////////////////////////////////////////////
		// Top - Set to the top of the content view instead of centered or top of left Title
        rightTopView.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
		
		constraint = NSLayoutConstraint(item: rightTopView,
		                                attribute: .top,
		                                relatedBy: .equal,
		                                toItem: self,
		                                attribute: .top,
		                                multiplier: 1.0,
		                                constant: topMargin)
		addConstraint(constraint)
		rightTopConstraint = constraint
		
		// Right
        if case let CardPartSecondaryTitleDescPosition.center(amount) = secondaryPos {
            constraint = NSLayoutConstraint(item: rightTopView,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .centerX,
                                            multiplier: 1.0,
                                            constant: amount)
            addConstraint(constraint)
        } else {
            constraint = NSLayoutConstraint(item: rightTopView,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .right,
                                            multiplier: 1.0,
                                            constant: -rightMargin)
            addConstraint(constraint)
            
            // Left - Keep the right and left labels at least X apart
            constraint = NSLayoutConstraint(item: rightTopView,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: leftTopView,
                                            attribute: .right,
                                            multiplier: 1.0,
                                            constant: 20)
            addConstraint(constraint)
        }
		
		// Right Bottom View ////////////////////////////////////////////////////////////////////////////////
		// Top
        rightBottomView.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        rightBottomView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)

		constraint = NSLayoutConstraint(item: rightBottomView,
		                                attribute: .top,
		                                relatedBy: .equal,
		                                toItem: rightTopView,
		                                attribute: .bottom,
		                                multiplier: 1.0,
		                                constant: verticalMarginBetweenTitleAndDescription)
		addConstraint(constraint)
		
		// Right
        if case let CardPartSecondaryTitleDescPosition.center(amount) = secondaryPos {
            constraint = NSLayoutConstraint(item: rightBottomView,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .centerX,
                                            multiplier: 1.0,
                                            constant: amount)
            addConstraint(constraint)
        } else {
            constraint = NSLayoutConstraint(item: rightBottomView,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .right,
                                            multiplier: 1.0,
                                            constant: -rightMargin)
            addConstraint(constraint)
            
            // Left - Keep the right and left labels at least X apart
            constraint = NSLayoutConstraint(item: rightBottomView,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: leftBottomView,
                                            attribute: .right,
                                            multiplier: 1.0,
                                            constant: 20)
            addConstraint(constraint)
        }

	}
}

extension Reactive where Base: CardPartTitleDescriptionView {
	
	public var leftTitleText: Binder<String?>{
		return Binder(self.base) { (titleDescriptionView, leftTitleText) -> () in
			titleDescriptionView.leftTitleText = leftTitleText
		}
	}

	public var leftDescriptionText: Binder<String?>{
		return Binder(self.base) { (titleDescriptionView, leftDescriptionText) -> () in
			titleDescriptionView.leftDescriptionText = leftDescriptionText
		}
	}
	
	public var leftDescriptionAttributedText: Binder<NSAttributedString?>{
		return Binder(self.base) { (titleDescriptionView, leftDescriptionAttributedText) -> () in
			titleDescriptionView.leftDescriptionAttributedText = leftDescriptionAttributedText
		}
	}
    
    public var leftTitleAttributedText: Binder<NSAttributedString?>{
        return Binder(self.base) { (titleDescriptionView, leftTitleAttributedText) -> () in
            titleDescriptionView.leftTitleAttributedText = leftTitleAttributedText
        }
    }
    
	public var rightDescriptionAttributedText: Binder<NSAttributedString?>{
		return Binder(self.base) { (titleDescriptionView, rightDescriptionAttributedText) -> () in
			titleDescriptionView.rightDescriptionAttributedText = rightDescriptionAttributedText
		}
	}
    
    public var rightTitleAttributedText: Binder<NSAttributedString?>{
        return Binder(self.base) { (titleDescriptionView, rightTitleAttributedText) -> () in
            titleDescriptionView.rightTitleAttributedText = rightTitleAttributedText
        }
    }

	public var rightTitleText: Binder<String?>{
		return Binder(self.base) { (titleDescriptionView, rightTitleText) -> () in
			titleDescriptionView.rightTitleText = rightTitleText
		}
	}

	public var rightDescriptionText: Binder<String?>{
		return Binder(self.base) { (titleDescriptionView, rightDescriptionText) -> () in
			titleDescriptionView.rightDescriptionText = rightDescriptionText
		}
	}

	public var leftTitleFont: Binder<UIFont>{
		return Binder(self.base) { (titleDescriptionView, leftTitleFont) -> () in
			titleDescriptionView.leftTitleFont = leftTitleFont
		}
	}

	public var leftDescriptionFont: Binder<UIFont>{
		return Binder(self.base) { (titleDescriptionView, leftDescriptionFont) -> () in
			titleDescriptionView.leftDescriptionFont = leftDescriptionFont
		}
	}

	public var rightTitleFont: Binder<UIFont>{
		return Binder(self.base) { (titleDescriptionView, rightTitleFont) -> () in
			titleDescriptionView.rightTitleFont = rightTitleFont
		}
	}

	public var rightDescriptionFont: Binder<UIFont>{
		return Binder(self.base) { (titleDescriptionView, rightDescriptionFont) -> () in
			titleDescriptionView.rightDescriptionFont = rightDescriptionFont
		}
	}

	public var leftTitleColor: Binder<UIColor>{
		return Binder(self.base) { (titleDescriptionView, leftTitleColor) -> () in
			titleDescriptionView.leftTitleColor = leftTitleColor
		}
	}

	public var leftDescriptionColor: Binder<UIColor>{
		return Binder(self.base) { (titleDescriptionView, leftDescriptionColor) -> () in
			titleDescriptionView.leftDescriptionColor = leftDescriptionColor
		}
	}
	
	public var rightTitleColor: Binder<UIColor>{
		return Binder(self.base) { (titleDescriptionView, rightTitleColor) -> () in
			titleDescriptionView.rightTitleColor = rightTitleColor
		}
	}

	public var rightDescriptionColor: Binder<UIColor>{
		return Binder(self.base) { (titleDescriptionView, rightDescriptionColor) -> () in
			titleDescriptionView.rightDescriptionColor = rightDescriptionColor
		}
	}

}
