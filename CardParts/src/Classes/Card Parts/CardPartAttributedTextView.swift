//
//  CardPartAttributedTextView.swift
//  CardParts
//
//  Created by jloehr  on 12/9/19.
//

import UIKit
import RxSwift
import RxCocoa

public class CardPartUITextView: UITextView {
    
    /// prevents blue background from a selection
    public override var selectedTextRange: UITextRange? {
        get { return nil }
        set {}
    }
    
    /// prevents selection except in the case of links
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // compatibility with isScrollEnabled
        if gestureRecognizer is UIPanGestureRecognizer {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        /// compatibility with links
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
            tapGestureRecognizer.numberOfTapsRequired == 1 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        /// differentiates between short press and a longer press
        if let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer,
            longPressGestureRecognizer.minimumPressDuration < 0.325 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        /// makes this card part unresonsive to touch
        gestureRecognizer.isEnabled = false
        return false
    }
    
    
    public var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override public func frame(forAlignmentRect alignmentRect: CGRect) -> CGRect {
        var resultRect = super.frame(forAlignmentRect: alignmentRect)
        
        resultRect.origin.y = bounds.origin.y + (bounds.size.height - resultRect.size.height) / 2
        return resultRect
    }
    
    override public func draw(_ rect: CGRect) {
        let rect = self.frame(forAlignmentRect: rect)
        super.draw(rect)
    }
}

public enum CardPartAttributedTextType {
    case small
    case normal
    case title
    case header
    case detail
}

public class CardPartAttributedTextView: UIView, CardPartView {
    /// use in cases of plain text
    public var text: String? {
        didSet {
            DispatchQueue.main.async {
                self.textView.text = self.text
            }
        }
    }
    /// use in cases of links or other
    public var attributedText: NSMutableAttributedString? {
        didSet {
            DispatchQueue.main.async {
                self.textView.attributedText = self.attributedText
            }
        }
    }
    /// set text font
    public var font: UIFont? {
        didSet {
            DispatchQueue.main.async {
                self.textView.font = self.font
            }
        }
    }
    /// set text color
    public var textColor: UIColor? {
        didSet {
            DispatchQueue.main.async {
                self.textView.textColor = self.textColor
            }
        }
    }
    /// set whether the text within a text field is editable
    public var isEditable: Bool {
        didSet {
            DispatchQueue.main.async {
                self.textView.isEditable = self.isEditable
            }
        }
    }
    /// use to specify data that should automatically be passed toother applications as URLs, e.g. phone numbers
    public var dataDetectorTypes: UIDataDetectorTypes {
        didSet {
            DispatchQueue.main.async {
                self.textView.dataDetectorTypes = self.dataDetectorTypes
            }
        }
    }
    /// use to specify text alignment wthin the text field
    public var textAlignment: NSTextAlignment {
        didSet {
            DispatchQueue.main.async {
                self.textView.textAlignment = self.textAlignment
            }
        }
    }
    /// set attributes of linked text
    public var linkTextAttributes: [NSAttributedString.Key : Any] {
        didSet {
            DispatchQueue.main.async {
                self.textView.linkTextAttributes = self.linkTextAttributes
            }
        }
    }
    
    /// allows for exclusion paths to be added for text wrapping
    public var exclusionPath: [UIBezierPath]? {
        didSet {
            DispatchQueue.main.async {
                let imageFrame = self.updateExclusionPath()
                let exclusionPath = UIBezierPath(rect: imageFrame)
                self.textView.textContainer.exclusionPaths = [exclusionPath]
            }
        }
    }
    /// set line spacing
    public var lineSpacing: CGFloat = 1.0 {
        didSet {
            DispatchQueue.main.async {
                let style = NSMutableParagraphStyle()
                style.lineSpacing = self.lineSpacing
            }
        }
    }
    /// set line height
    public var lineHeightMultiple: CGFloat = 1.1 {
        didSet {
            DispatchQueue.main.async {
                let style = NSMutableParagraphStyle()
                style.lineHeightMultiple = self.lineHeightMultiple
            }
        }
    }
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    /// allows for modifications to the text as if it were a UITextView
    public var textView: CardPartUITextView
    
    /// supports nested images in textfield
    public var textViewImage: CardPartImageView?
    
    public init(type: CardPartAttributedTextType) {
        
        textView = CardPartUITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        textView.isScrollEnabled = false
        textView.text = text
        textView.backgroundColor = CardParts.theme.attributedTextBackgroundColor
        textView.isEditable = false
        self.textView.isSelectable = textView.isSelectable
        self.isEditable = textView.isEditable
        self.dataDetectorTypes = textView.dataDetectorTypes
        self.textAlignment = textView.textAlignment
        self.linkTextAttributes = textView.linkTextAttributes
        self.exclusionPath = textView.textContainer.exclusionPaths
        
        super.init(frame: CGRect.zero)

        addSubview(textView)
        setDefaultsForType(type)
        setNeedsUpdateConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// allows for constraints to be set 
    override public func updateConstraints() {
        
        textView.layout {
            $0.leading == self.leadingAnchor
            $0.trailing == self.trailingAnchor
            $0.top == self.topAnchor
            $0.bottom == self.bottomAnchor
        }
        
        super.updateConstraints()
    }
    
    func setDefaultsForType(_ type: CardPartAttributedTextType) {
        switch type {
        case .small:
            font = CardParts.theme.smallAttributedTextFont
            textColor = CardParts.theme.smallAttributedTextColor
        case .normal:
            font = CardParts.theme.normalAttributedTextFont
            textColor = CardParts.theme.normalAttributedTextColor
        case .title:
            font = CardParts.theme.titleAttributedTextFont
            textColor = CardParts.theme.titleAttributedTextColor
        case .header:
            font = CardParts.theme.headerAttributedTextFont
            textColor = CardParts.theme.headerAttributedTextColor
        case .detail:
            font = CardParts.theme.detailAttributedTextFont
            textColor = CardParts.theme.detailAttributedTextColor
        }
    }
    
    /// returns image perimeter for text to wrap around
    func updateExclusionPath() -> CGRect {
        let x = textViewImage?.frame.origin.x ?? 0
        let y = textViewImage?.frame.origin.y ?? 0
        let height = textViewImage?.frame.height ?? 0
        let width = textViewImage?.frame.width ?? 0
        let imageRect = CGRect(x: x, y: y, width: width, height: height)
        return imageRect
    }
    
}

extension Reactive where Base: CardPartAttributedTextView {
    
    public var text: Binder<String?> {
        return Binder<String?>(self.base) { (textView, text) -> () in
            textView.text = text
        }
    }
    
    public var attributedText: Binder<NSMutableAttributedString?> {
        return Binder<NSMutableAttributedString?>(self.base) { (textView, attributedText) -> () in
            textView.attributedText = attributedText
        }
    }
    
    public var font: Binder<UIFont> {
        return Binder(self.base) { (textView, font) -> () in
            textView.font = font
        }
    }
    
    public var textColor: Binder<UIColor> {
        return Binder(self.base) { (textView, textColor) -> () in
            textView.textColor = textColor
        }
    }
    
    public var isEditable: Binder<Bool> {
        return Binder(self.base) { (textView, isEditable) -> () in
            textView.isEditable = isEditable
        }
    }
    
    public var dataDetectorTypes: Binder<UIDataDetectorTypes> {
        return Binder(self.base) { (textView, dataDetectorTypes) -> () in
            textView.dataDetectorTypes = dataDetectorTypes
        }
    }
    
    public var textAlignment: Binder<NSTextAlignment> {
        return Binder(self.base) { (textView, textAlignment) -> () in
            textView.textAlignment = textAlignment
        }
    }
    
    public var exclusionPath: Binder<[UIBezierPath]?> {
        return Binder(self.base) { (textView, exclusionPath) -> () in
            textView.exclusionPath = exclusionPath
        }
    }
    
    public var lineSpacing: Binder<CGFloat> {
        return Binder(self.base) { (textView, lineSpacing) -> () in
            textView.lineSpacing = lineSpacing
        }
    }

    public var lineHeightMultiple: Binder<CGFloat> {
        return Binder(self.base) { (textView, lineHeightMultiple) -> () in
            textView.lineHeightMultiple = lineHeightMultiple
        }
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
}
