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

/// Label vertical alignment
public enum CardPartLabelVerticalAlignment {
    /// top
    case top
    /// center
    case center
    /// bottom
    case bottom
}

/// Label
public class CardPartLabel: UILabel {
    
    /// Default: `.zero`
    public var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    fileprivate var verticalAlignment: CardPartLabelVerticalAlignment = .center
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var resultRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        switch verticalAlignment {
        case .top:
            break
        case .center:
            resultRect.origin.y = bounds.origin.y + (bounds.size.height - resultRect.size.height) / 2
        case .bottom:
            resultRect.origin.y = bounds.origin.y + (bounds.size.height - resultRect.size.height)
        }
        
        resultRect.origin.y += textInsets.top - textInsets.bottom
        resultRect.origin.x += textInsets.left - textInsets.right
        
        resultRect.size.height += textInsets.top
        resultRect.size.height += textInsets.bottom
        
        return resultRect
    }

    
    override public func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: r)
    }
}


/// Text sizing
public enum CardPartTextType {
    /// small
    case small
    /// normal
	case normal
    /// title
	case title
    /// header
    case header
    /// detail
	case detail
}

///CardPartTextView displays a single text string. The string can wrap to multiple lines. The initializer for CardPartTextView takes a type parameter which can be set to: normal, title, or detail. The type is used to set the default font and textColor for the text.
///
///CardPartTextView exposes the following reactive properties that can be bound to view model properties:
///```
///var text: String?
///var attributedText: NSAttributedString?
///var font: UIFont!
///var textColor: UIColor!
///var textAlignment: NSTextAlignment
///var lineSpacing: CGFloat
///var lineHeightMultiple: CGFloat
///var alpha: CGFloat
///var backgroundColor: UIColor?
///var isHidden: Bool
///var isUserInteractionEnabled: Bool
///var tintColor: UIColor?
///```
public class CardPartTextView : UIView, CardPartView {
	
    /// Text
	public var text: String? {
		didSet {
			updateText()
		}
	}
	
    /// Attributed text
	public var attributedText: NSAttributedString? {
		didSet {
			updateText()
		}
	}
	
    /// UIFont
	public var font: UIFont! {
		didSet {
			updateText()
		}
	}
	
    /// UIColor
	public var textColor: UIColor! {
		didSet {
			updateText()
		}
	}
	
    /// `.left` by default
	public var textAlignment: NSTextAlignment = .left {
		didSet {
			updateText()
		}
	}
	
    /// `.center by default
    public var verticalAlignment: CardPartLabelVerticalAlignment = .center {
        didSet {
            updateText()
        }
    }

    /// 1.0 by default
    public var lineSpacing: CGFloat = 1.0 {
		didSet {
			updateText()
		}
	}
	
    /// 1.1 by default
	public var lineHeightMultiple: CGFloat = 1.1 {
		didSet {
			updateText()
		}
	}
	
    /// CardParts theme margins by default
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
    /// `CardPartLabel`
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
	
    @objc func updateText() {
		
        if Thread.current != .main {
            self.performSelector(onMainThread: #selector(CardPartTextView.updateText), with: nil, waitUntilDone: false)
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        if let labelText = attributedText {
            let mutableAttrText = NSMutableAttributedString(attributedString: labelText)
            
            mutableAttrText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                          range: NSRange(location: 0, length: mutableAttrText.length))
            
            label.attributedText = mutableAttrText
        } else if let labelText = text {
            let mutableAttrText = NSMutableAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: textColor!])
            
            mutableAttrText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                          range: NSRange(location: 0, length: mutableAttrText.length))
            label.attributedText = mutableAttrText
        } else {
            label.attributedText = nil
        }
        label.textAlignment = textAlignment
        label.verticalAlignment = verticalAlignment
	}
}

extension Reactive where Base: CardPartTextView {
	
    /// Updates textView's text
	public var text: Binder<String?>{
		return Binder(self.base) { (textView, text) -> () in
			textView.text = text
		}
	}
	
    /// Updates textView's attributedText
	public var attributedText: Binder<NSAttributedString?>{
		return Binder(self.base) { (textView, attributedText) -> () in
			textView.attributedText = attributedText
		}
	}

    /// Updates textView's font
	public var font: Binder<UIFont>{
		return Binder(self.base) { (textView, font) -> () in
			textView.font = font
		}
	}
	
    /// Updates textView's textColor
	public var textColor: Binder<UIColor>{
		return Binder(self.base) { (textView, textColor) -> () in
			textView.textColor = textColor
		}
	}
	
    /// Updates textView's textAlignment
	public var textAlignment: Binder<NSTextAlignment>{
		return Binder(self.base) { (textView, textAlignment) -> () in
			textView.textAlignment = textAlignment
		}
	}
	
    /// Updates textView's verticalAlignment
    public var verticalAlignment: Binder<CardPartLabelVerticalAlignment>{
        return Binder(self.base) { (textView, verticalAlignment) -> () in
            textView.verticalAlignment = verticalAlignment
        }
    }

    /// Updates textView's lineSpacing
    public var lineSpacing: Binder<CGFloat>{
		return Binder(self.base) { (textView, lineSpacing) -> () in
			textView.lineSpacing = lineSpacing
		}
	}
	
    /// Updates textView's lineHeightMultiple
	public var lineHeightMultiple: Binder<CGFloat>{
		return Binder(self.base) { (textView, lineHeightMultiple) -> () in
			textView.lineHeightMultiple = lineHeightMultiple
		}
	}
}

