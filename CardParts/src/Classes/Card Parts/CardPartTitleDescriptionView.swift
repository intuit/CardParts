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

/// Title position
public enum CardPartTitlePosition {
    /// top
	case top
    /// bottom
	case bottom
}

/// Compression
public enum CardPartTitleCompression {
    /// left
	case left
    /// right
	case right
}

/// Secondary Position
public enum CardPartSecondaryTitleDescPosition {
    /// center, amount: shifted
    case center(amount: CGFloat)
    /// right
    case right
}

/// CardPartTitleDescriptionView allows you to have a left and right title and description label, however, you are able to also choose the alignment of the right title/description labels. See below:
///```
///let rightAligned = CardPartTitleDescriptionView(titlePosition: .top, secondaryPosition: .right) // This will be right aligned
///let centerAligned = CardPartTitleDescriptionView(titlePosition: .top, secondaryPosition: .center(amount: 0)) // This will be center aligned with an offset of 0.  You may increase that amount param to shift right your desired amount
///```
/// <h3>Reactive Properties</h3>
///```
///leftTitleText: String
///leftDescriptionText: String
///leftDescriptionAttributedText: NSAttributedString
///leftTitleAttributedText: NSAttributedString
///rightDescriptionAttributedText: NSAttributedString
///rightTitleAttributedText: NSAttributedString
///rightTitleText: String
///rightDescriptionText: String
///leftTitleFont: UIFont
///leftDescriptionFont: UIFont
///rightTitleFont: UIFont
///rightDescriptionFont: UIFont
///leftTitleColor: UIColor
///leftDescriptionColor: UIColor
///rightTitleColor: UIColor
///rightDescriptionColor: UIColor
///```
public class CardPartTitleDescriptionView : UIView, CardPartView {
	
    /// CardParts theme margins by default
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
    /// Label in upper left position
	public var leftTitleLabel: UILabel
    /// Label in bottom left position
	public var leftDescriptionLabel: UILabel
    /// Label in upper fight position
	public var rightTitleLabel: UILabel
    /// Label in lower right position
	public var rightDescriptionLabel: UILabel
	
    /// Text for left title
	public var leftTitleText: String? {
		didSet {
			leftTitleLabel.text = leftTitleText
		}
	}

    /// Plain text for left description
	public var leftDescriptionText: String? {
		didSet {
			leftDescriptionLabel.text = leftDescriptionText
		}
	}
	
    /// Attributed text for left description
	public var leftDescriptionAttributedText: NSAttributedString? {
		didSet {
			leftDescriptionLabel.attributedText = leftDescriptionAttributedText
		}
	}
    
    /// Attributed text for left title
    public var leftTitleAttributedText: NSAttributedString? {
        didSet {
            leftTitleLabel.attributedText = leftTitleAttributedText
        }
    }
	
    /// Plain text for right title
	public var rightTitleText: String? {
		didSet {
			rightTitleLabel.text = rightTitleText
		}
	}
	
    /// Plain text for right description
	public var rightDescriptionText: String? {
		didSet {
			rightDescriptionLabel.text = rightDescriptionText
		}
	}
	
    /// Attributed text for right description
	public var rightDescriptionAttributedText: NSAttributedString? {
		didSet {
			rightDescriptionLabel.attributedText = rightDescriptionAttributedText
		}
	}
    
    /// Attributed text for right title
    public var rightTitleAttributedText: NSAttributedString? {
        didSet {
            rightTitleLabel.attributedText = rightTitleAttributedText
        }
    }
	
    /// Font for left title
	public var leftTitleFont: UIFont = CardParts.theme.leftTitleFont {
		didSet {
			leftTitleLabel.font = leftTitleFont
		}
	}
    /// Font for left description
	public var leftDescriptionFont: UIFont = CardParts.theme.leftDescriptionFont {
		didSet {
			leftDescriptionLabel.font = leftDescriptionFont
		}
	}
    /// Font for right title
	public var rightTitleFont: UIFont = CardParts.theme.rightTitleFont {
		didSet {
			rightTitleLabel.font = rightTitleFont
		}
	}
    /// Font for right description
	public var rightDescriptionFont: UIFont = CardParts.theme.rightDescriptionFont {
		didSet {
			rightDescriptionLabel.font = rightDescriptionFont
		}
	}
	
    /// Color for left title
	public var leftTitleColor: UIColor = CardParts.theme.leftTitleColor {
		didSet {
			leftTitleLabel.textColor = leftTitleColor
		}
	}
    /// Color for left description
	public var leftDescriptionColor: UIColor = CardParts.theme.leftDescriptionColor {
		didSet {
			leftDescriptionLabel.textColor = leftDescriptionColor
		}
	}
    /// Color for right title
	public var rightTitleColor: UIColor = CardParts.theme.rightTitleColor {
		didSet {
			rightTitleLabel.textColor = rightTitleColor
		}
	}
    /// Color for right description
	public var rightDescriptionColor: UIColor = CardParts.theme.rightDescriptionColor {
		didSet {
			rightDescriptionLabel.textColor = rightDescriptionColor
		}
	}
	
    /// Compression for title, `.right` by default
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

    /// Initializes a CardPartTitleDescriptionView, defaulting to `.top` and CardParts theme `secondaryTitlePosition`
    ///
    /// - Parameters:
    ///   - titlePosition: position of title
    ///   - secondaryPosition: alignment of other title/description
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
	
    /// Required init
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    /// Update constraints based on title/description text existence and compression settings
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
	
    /// Manually configure constraints based on titles and descriptions existing, and initializer configuration
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
	
    /// Updates titleDescriptionView's leftTitleText
	public var leftTitleText: Binder<String?>{
		return Binder(self.base) { (titleDescriptionView, leftTitleText) -> () in
			titleDescriptionView.leftTitleText = leftTitleText
		}
	}

    /// Updates titleDescriptionView's leftDescriptionText
	public var leftDescriptionText: Binder<String?>{
		return Binder(self.base) { (titleDescriptionView, leftDescriptionText) -> () in
			titleDescriptionView.leftDescriptionText = leftDescriptionText
		}
	}
	
    /// Updates titleDescriptionView's leftDescriptionAttributedText
	public var leftDescriptionAttributedText: Binder<NSAttributedString?>{
		return Binder(self.base) { (titleDescriptionView, leftDescriptionAttributedText) -> () in
			titleDescriptionView.leftDescriptionAttributedText = leftDescriptionAttributedText
		}
	}
    
    /// Updates titleDescriptionView's leftTitleAttributedText
    public var leftTitleAttributedText: Binder<NSAttributedString?>{
        return Binder(self.base) { (titleDescriptionView, leftTitleAttributedText) -> () in
            titleDescriptionView.leftTitleAttributedText = leftTitleAttributedText
        }
    }
    
    /// Updates titleDescriptionView's rightDescriptionAttributedText
	public var rightDescriptionAttributedText: Binder<NSAttributedString?>{
		return Binder(self.base) { (titleDescriptionView, rightDescriptionAttributedText) -> () in
			titleDescriptionView.rightDescriptionAttributedText = rightDescriptionAttributedText
		}
	}
    
    /// Updates titleDescriptionView's rightTitleAttributedText
    public var rightTitleAttributedText: Binder<NSAttributedString?>{
        return Binder(self.base) { (titleDescriptionView, rightTitleAttributedText) -> () in
            titleDescriptionView.rightTitleAttributedText = rightTitleAttributedText
        }
    }

    /// Updates titleDescriptionView's rightTitleText
	public var rightTitleText: Binder<String?>{
		return Binder(self.base) { (titleDescriptionView, rightTitleText) -> () in
			titleDescriptionView.rightTitleText = rightTitleText
		}
	}

    /// Updates titleDescriptionView's rightDescriptionText
	public var rightDescriptionText: Binder<String?>{
		return Binder(self.base) { (titleDescriptionView, rightDescriptionText) -> () in
			titleDescriptionView.rightDescriptionText = rightDescriptionText
		}
	}

    /// Updates titleDescriptionView's leftTitleFont
	public var leftTitleFont: Binder<UIFont>{
		return Binder(self.base) { (titleDescriptionView, leftTitleFont) -> () in
			titleDescriptionView.leftTitleFont = leftTitleFont
		}
	}

    /// Updates titleDescriptionView's leftDescriptionFont
	public var leftDescriptionFont: Binder<UIFont>{
		return Binder(self.base) { (titleDescriptionView, leftDescriptionFont) -> () in
			titleDescriptionView.leftDescriptionFont = leftDescriptionFont
		}
	}

    /// Updates titleDescriptionView's rightTitleFont
	public var rightTitleFont: Binder<UIFont>{
		return Binder(self.base) { (titleDescriptionView, rightTitleFont) -> () in
			titleDescriptionView.rightTitleFont = rightTitleFont
		}
	}

    /// Updates titleDescriptionView's rightDescriptionFont
	public var rightDescriptionFont: Binder<UIFont>{
		return Binder(self.base) { (titleDescriptionView, rightDescriptionFont) -> () in
			titleDescriptionView.rightDescriptionFont = rightDescriptionFont
		}
	}

    /// Updates titleDescriptionView's leftTitleColor
	public var leftTitleColor: Binder<UIColor>{
		return Binder(self.base) { (titleDescriptionView, leftTitleColor) -> () in
			titleDescriptionView.leftTitleColor = leftTitleColor
		}
	}

    /// Updates titleDescriptionView's leftDescriptionColor
	public var leftDescriptionColor: Binder<UIColor>{
		return Binder(self.base) { (titleDescriptionView, leftDescriptionColor) -> () in
			titleDescriptionView.leftDescriptionColor = leftDescriptionColor
		}
	}
	
    /// Updates titleDescriptionView's rightTitleColor
	public var rightTitleColor: Binder<UIColor>{
		return Binder(self.base) { (titleDescriptionView, rightTitleColor) -> () in
			titleDescriptionView.rightTitleColor = rightTitleColor
		}
	}

    /// Updates titleDescriptionView's rightDescriptionColor
	public var rightDescriptionColor: Binder<UIColor>{
		return Binder(self.base) { (titleDescriptionView, rightDescriptionColor) -> () in
			titleDescriptionView.rightDescriptionColor = rightDescriptionColor
		}
	}

}
