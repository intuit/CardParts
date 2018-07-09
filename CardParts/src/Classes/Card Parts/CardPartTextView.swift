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

public class CardPartLabel: UILabel {
    public var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}

public extension CardPartLabel {
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

public enum CardPartTextType {
	case small
	case normal
	case title
    case header
	case detail
}

public class CardPartTextView : UIView, CardPartView {
	
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
	
	public var label: CardPartLabel

	public init(type: CardPartTextType) {

		label = CardPartLabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0

		font = label.font
		textColor = label.textColor
		
        super.init(frame: CGRect.zero)

		addSubview(label)
		
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

            label.attributedText = mutableAttrText
            label.textAlignment = textAlignment
		} else if let labelText = text {
			let mutableAttrText = NSMutableAttributedString(string: labelText, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: textColor])
			
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = lineSpacing
			paragraphStyle.lineHeightMultiple = lineHeightMultiple
			
            mutableAttrText.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle],
			                              range: NSRange(location: 0, length: mutableAttrText.length))
			label.font = font
			label.attributedText = mutableAttrText
            label.textAlignment = textAlignment
		} else {
            label.attributedText = nil
		}
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

