//
//  CardPartTableViewCell.swift
//  Gala
//
//  Created by Kier, Tom on 2/23/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import Foundation
import UIKit


public class CardPartTableViewCell : UITableViewCell {
	
    public var margins: UIEdgeInsets = .init(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)

    public var leftTitleLabel: UILabel
	public var leftDescriptionLabel: UILabel
	public var rightTitleLabel: UILabel
	public var rightDescriptionLabel: UILabel
	public var rightTopButton: UIButton
	public var shouldCenterRightLabel = false

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
	
	public var displayAsHidden: Bool = false {
		didSet {
			leftTitleLabel.textColor = displayAsHidden ? UIColor.Gray2 : leftTitleColor
			rightTitleLabel.textColor = displayAsHidden ? UIColor.Gray2 : rightTitleColor
			leftDescriptionLabel.textColor = displayAsHidden ? UIColor.Gray2 : leftDescriptionColor
			rightDescriptionLabel.textColor = displayAsHidden ? UIColor.Gray2 : rightDescriptionColor
			
			leftTitleLabel.alpha = displayAsHidden ? 0.6 : 1.0
			rightTitleLabel.alpha = displayAsHidden ? 0.6 : 1.0
			leftDescriptionLabel.alpha = displayAsHidden ? 0.6 : 1.0
			rightDescriptionLabel.alpha = displayAsHidden ? 0.6 : 1.0
			
			backgroundColor = displayAsHidden ? UIColor.Gray6 : UIColor.white
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


	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

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
		
		rightTopButton = UIButton(type: .system)
		rightTopButton.translatesAutoresizingMaskIntoConstraints = false

		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
		
		
		for subview in contentView.subviews {
			subview.removeFromSuperview()
		}
		
		contentView.addSubview(leftTitleLabel)
		contentView.addSubview(leftDescriptionLabel)
		contentView.addSubview(rightTitleLabel)
		contentView.addSubview(rightDescriptionLabel)
		contentView.addSubview(rightTopButton)
        
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
			contentView.removeConstraint(rightTopConstraint)
			let constraint = NSLayoutConstraint(item: rightTitleLabel,
			                                    attribute: .centerY,
			                                    relatedBy: .equal,
			                                    toItem: contentView,
			                                    attribute: .centerY,
			                                    multiplier: 1.0,
			                                    constant: 0.0)
			contentView.addConstraint(constraint)
		}
		if leftDescriptionLabel.text == nil || leftDescriptionLabel.text?.count == 0 {
			contentView.removeConstraint(leftTopConstraint)
			let constraint = NSLayoutConstraint(item: leftTitleLabel,
			                                    attribute: .centerY,
			                                    relatedBy: .equal,
			                                    toItem: contentView,
			                                    attribute: .centerY,
			                                    multiplier: 1.0,
			                                    constant: 0.0)
			contentView.addConstraint(constraint)
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
		
		let topMargin: CGFloat = margins.top
		let leftMargin: CGFloat = margins.left
		let rightMargin: CGFloat = shouldCenterRightLabel ? (self.bounds.size.width/2 - rightTitleLabel.sizeThatFits(CGSize.zero).width) : margins.right
		let verticalMarginBetweenTitleAndDescription: CGFloat = 2
		
		// Left Title ////////////////////////////////////////////////////////////////////////////////
		// Top
        leftTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
		
		var constraint = NSLayoutConstraint(item: leftTitleLabel,
		                                    attribute: .top,
		                                    relatedBy: .equal,
		                                    toItem: contentView,
		                                    attribute: .top,
		                                    multiplier: 1.0,
		                                    constant: topMargin)
		contentView.addConstraint(constraint)
		leftTopConstraint = constraint

		// Left
		constraint = NSLayoutConstraint(item: leftTitleLabel,
		                                attribute: .left,
		                                relatedBy: .equal,
		                                toItem: contentView,
		                                attribute: .left,
		                                multiplier: 1.0,
		                                constant: leftMargin)
		contentView.addConstraint(constraint)
		
		// Left Description ////////////////////////////////////////////////////////////////////////////////
		// Top
		constraint = NSLayoutConstraint(item: leftDescriptionLabel,
		                                attribute: .top,
		                                relatedBy: .equal,
		                                toItem: leftTitleLabel,
		                                attribute: .bottom,
		                                multiplier: 1.0,
		                                constant: verticalMarginBetweenTitleAndDescription)
		contentView.addConstraint(constraint)
		
		// Left
		constraint = NSLayoutConstraint(item: leftDescriptionLabel,
		                                attribute: .left,
		                                relatedBy: .equal,
		                                toItem: contentView,
		                                attribute: .left,
		                                multiplier: 1.0,
		                                constant: leftMargin)
		contentView.addConstraint(constraint)
		
		// Right
		constraint = NSLayoutConstraint(item: leftDescriptionLabel,
		                                attribute: .right,
		                                relatedBy: .equal,
		                                toItem: contentView,
		                                attribute: .right,
		                                multiplier: 1.0,
		                                constant: 0)
		contentView.addConstraint(constraint)
        		
		// Right Title ////////////////////////////////////////////////////////////////////////////////
		// Top - Set to the top of the content view instead of centered or top of left Title
        rightTitleLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
		
		constraint = NSLayoutConstraint(item: rightTitleLabel,
		                                attribute: .top,
		                                relatedBy: .equal,
		                                toItem: contentView,
		                                attribute: .top,
		                                multiplier: 1.0,
		                                constant: topMargin)
		contentView.addConstraint(constraint)
		rightTopConstraint = constraint
		
		// Right
		constraint = NSLayoutConstraint(item: rightTitleLabel,
		                                attribute: .right,
		                                relatedBy: .equal,
		                                toItem: contentView,
		                                attribute: .right,
		                                multiplier: 1.0,
		                                constant: -rightMargin)
		contentView.addConstraint(constraint)
		
		// Left - Keep the right and left labels at least X apart
		constraint = NSLayoutConstraint(item: rightTitleLabel,
		                                attribute: .left,
		                                relatedBy: .equal,
		                                toItem: leftTitleLabel,
		                                attribute: .right,
		                                multiplier: 1.0,
		                                constant: 20)
		contentView.addConstraint(constraint)
		
		// Right Description ////////////////////////////////////////////////////////////////////////////////
		// Top
		constraint = NSLayoutConstraint(item: rightDescriptionLabel,
		                                attribute: .top,
		                                relatedBy: .equal,
		                                toItem: rightTitleLabel,
		                                attribute: .bottom,
		                                multiplier: 1.0,
		                                constant: verticalMarginBetweenTitleAndDescription)
		contentView.addConstraint(constraint)
		
		// Right
		let nsAttributeType: NSLayoutConstraint.Attribute = shouldCenterRightLabel ? .left : .right
		constraint = NSLayoutConstraint(item: rightDescriptionLabel,
		                                attribute: nsAttributeType,
		                                relatedBy: .equal,
		                                toItem: rightTitleLabel,
		                                attribute: nsAttributeType,
		                                multiplier: 1.0,
		                                constant: 0)
		contentView.addConstraint(constraint)
		
		// Right Top Button  ////////////////////////////////////////////////////////////////////////////////
		// Top - Set to the top of the content view instead of centered or top of left Title
        rightTopButton.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
		
		constraint = NSLayoutConstraint(item: rightTopButton,
		                                attribute: .top,
		                                relatedBy: .equal,
		                                toItem: contentView,
		                                attribute: .top,
		                                multiplier: 1.0,
		                                constant: 4)
		contentView.addConstraint(constraint)
		
		// Right
		constraint = NSLayoutConstraint(item: rightTopButton,
		                                attribute: .right,
		                                relatedBy: .equal,
		                                toItem: contentView,
		                                attribute: .right,
		                                multiplier: 1.0,
		                                constant: -15)
		contentView.addConstraint(constraint)

	}
}
