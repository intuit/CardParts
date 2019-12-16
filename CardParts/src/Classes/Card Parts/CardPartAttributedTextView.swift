//
//  CardPartAttributedTextView.swift
//  CardParts
//
//  Created by jloehr  on 12/9/19.
//

import UIKit
import RxSwift
import RxCocoa

public enum ContentVerticalAlignment {
    case top, center, bottom
}

public class CardPartMutableText: UITextView {
 
    //public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    

}

public enum CardPartMutableTextViewType {
    case small
    case normal
    case title
    case header
    case detail
}

public class CardPartMutableTextView: UIView, CardPartView {
    
    public var text: String? {
        didSet {
            
        }
    }
    
    public var attributedText: NSAttributedString? {
        didSet {
            
        }
    }
    
    public var font: UIFont? {
        didSet {
            
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            
        }
    }
    
    public var isEditable: Bool {
        didSet {
            
        }
    }
    
    public var dataDetectorTypes: UIDataDetectorTypes {
        didSet {
            
        }
    }
    
    public var textAlignment: NSTextAlignment {
        didSet {
            
        }
    }
    
    public var linkTextAttributes: [NSAttributedString.Key : Any] {
        didSet {
            
        }
    }
    
    public var lineSpacing: CGFloat = 1.0 {
        didSet {
            
        }
    }
    
    public var lineHeightMultiple: CGFloat = 1.1 {
        didSet {
            
        }
    }
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    public var textView: CardPartMutableText
    
    //public var exclusionPath: UIBezierPath
    
    public init(type: CardPartMutableTextViewType) {
        
        textView = CardPartMutableText(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        
        super.init(frame: CGRect.zero)
        
        addSubview(textView)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultsForType(_ type: CardPartMutableTextViewType) {
        isEditable = false
        
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
            self.performSelector(onMainThread: #selector(CardPartMutableTextView.updateText), with: nil, waitUntilDone: false)
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        if let viewText = attributedText {
            let attributedViewText = NSMutableAttributedString(attributedString: viewText)
            
            attributedViewText.addAttributes([NSAttributedString.Key.paragraphStyle:  paragraphStyle], range: NSRange(location: 0, length: attributedViewText.length))
            textView.attributedText = attributedViewText
        } else if let viewText = text {
            let attributedViewText = NSMutableAttributedString(string: viewText, attributes: [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: textColor!])
            attributedViewText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedViewText.length))
            textView.attributedText = attributedViewText
        } else {
            textView.attributedText = nil
        }
        textView.textAlignment = textAlignment
    }
}

extension UITextView {
    func center() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
//    func bottom() {
//        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
//        let size = sizeThatFits(fittingSize)
//        let topOffset = (bounds.size.height - size.height * zoomScale)
//        let positiveTopOffset = max(1, topOffset)
//        contentOffset.y = -positiveTopOffset
//    }
}
