//
//  CardPartTextView.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/17/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TTTAttributedLabel

public enum CardPartTextType {
	case small
	case normal
	case title
    case header
	case detail
}

public class CardPartTextView : UIView, CardPartView, TTTAttributedLabelDelegate {
	
	public var text: String? {
		didSet {
			updateText()
		}
	}
	
	public var attributedText: NSAttributedString? {
		didSet {
			updateText()
		}
	}
	
	public var font: UIFont! {
		didSet {
			updateText()
		}
	}
	
	public var textColor: UIColor! {
		didSet {
			updateText()
		}
	}
	
	public var textAlignment: NSTextAlignment = .left {
		didSet {
			updateText()
		}
	}
	
	public var lineSpacing: CGFloat = 1.0 {
		didSet {
			updateText()
		}
	}
	
	public var lineHeightMultiple: CGFloat = 1.1 {
		didSet {
			updateText()
		}
	}
	
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
	public var label: TTTAttributedLabel
	

	public init(type: CardPartTextType) {

		label = TTTAttributedLabel(frame: CGRect.zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0

		font = label.font
		textColor = label.textColor
		
        super.init(frame: CGRect.zero)

		label.delegate = self
		addSubview(label)
		
		setupLinkAttributes()
		setDefaultsForType(type)
		setNeedsUpdateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override public func updateConstraints() {
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label" : label]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label" : label]))
		
		super.updateConstraints()
	}
	
	func setupLinkAttributes() {
		let linkBlueColor = UIColor.turboBlueColor
		let activeLinkBlueColor = UIColor.turboBlueColor.withAlphaComponent(0.5)
		
		label.linkAttributes = [kCTForegroundColorAttributeName as String : linkBlueColor]
		label.activeLinkAttributes = [kCTForegroundColorAttributeName as String : activeLinkBlueColor]
	}
	
	func setDefaultsForType(_ type: CardPartTextType) {
		isUserInteractionEnabled = true

		switch type {
		case .small:
			font = CardParts.theme.smallTextFont
			textColor = CardParts.theme.smallTextColor
		case .normal:
			font = CardParts.theme.normalTextFont
			textColor = CardParts.theme.normalTextColor
		case .title:
			font = CardParts.theme.titleTextFont
			textColor = CardParts.theme.titleTextColor
        case .header:
            font = CardParts.theme.headerTextFont
            textColor = CardParts.theme.headerTextColor
		case .detail:
			font = CardParts.theme.detailTextFont
			textColor = CardParts.theme.detailTextColor
		}
	}
	
	func updateText() {
		
		if let labelText = attributedText {
			
			let mutableAttrText = NSMutableAttributedString(attributedString: labelText)
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = lineSpacing
			paragraphStyle.lineHeightMultiple = lineHeightMultiple

            mutableAttrText.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle],
										  range: NSRange(location: 0, length: mutableAttrText.length))

			label.textAlignment = textAlignment
			label.setText(mutableAttrText)
			
		} else if let labelText = text {
			let mutableAttrText = NSMutableAttributedString(string: labelText, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: textColor])
			
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = lineSpacing
			paragraphStyle.lineHeightMultiple = lineHeightMultiple
			
            mutableAttrText.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle],
			                              range: NSRange(location: 0, length: mutableAttrText.length))

			label.textAlignment = textAlignment
			label.setText(mutableAttrText)
			
		} else {
			label.setText(nil)
		}
	}
	
	public func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
}

extension Reactive where Base: CardPartTextView {
	
	public var text: Binder<String?>{
		return Binder(self.base) { (textView, text) -> () in
			textView.text = text
		}
	}
	
	public var attributedText: Binder<NSAttributedString?>{
		return Binder(self.base) { (textView, attributedText) -> () in
			textView.attributedText = attributedText
		}
	}

	public var font: Binder<UIFont>{
		return Binder(self.base) { (textView, font) -> () in
			textView.font = font
		}
	}
	
	public var textColor: Binder<UIColor>{
		return Binder(self.base) { (textView, textColor) -> () in
			textView.textColor = textColor
		}
	}
	
	public var textAlignment: Binder<NSTextAlignment>{
		return Binder(self.base) { (textView, textAlignment) -> () in
			textView.textAlignment = textAlignment
		}
	}
	
	public var lineSpacing: Binder<CGFloat>{
		return Binder(self.base) { (textView, lineSpacing) -> () in
			textView.lineSpacing = lineSpacing
		}
	}
	
	public var lineHeightMultiple: Binder<CGFloat>{
		return Binder(self.base) { (textView, lineHeightMultiple) -> () in
			textView.lineHeightMultiple = lineHeightMultiple
		}
	}
}

