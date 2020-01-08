//
//  CardPartIconLabel.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 8/20/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class CardPartIconLabel: UILabel, CardPartView {
    
    public enum HorizontalPosition {
        case left
        case right
    }
    
    public enum VerticalPosition {
        case top
        case center
        case bottom
    }
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    /// provides vertical and horizontal spacing
    public var verticalPadding:CGFloat = 2.0
    public var horizontalPadding:CGFloat = 2.0
    public var padding:CGFloat = 10.0
    
    public var iconView: UIImageView? {
        didSet {
            guard let image = iconView?.image else { return }
            self.icon = image
        }
    }
    
    fileprivate var iconViewPosition:CGPoint = CGPoint.zero
    
    /// Horizontal and vertical position
    public typealias Position = (horizontal: CardPartIconLabel.HorizontalPosition, vertical: CardPartIconLabel.VerticalPosition)
    open var iconPosition: Position = (.left , .top)
    
    /// additional spacing between text and the image
    public var iconPadding: CGFloat = 0
    
    public var icon:UIImage? {
        didSet {
            if icon == nil {
                iconView?.removeFromSuperview()
            }
            setNeedsDisplay()
        }
    }
    
    public var labelText: String? {
        didSet {
            guard let text = labelText else { return }
            self.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.clipsToBounds = true
    }
    
    private func getAdjustedTextSize() -> CGSize? {
        guard let text = text as NSString?, let icon = icon else { return nil }
        return text.boundingRect(with: CGSize(width: frame.width - icon.size.width - iconPadding - padding * 2, height: .greatestFiniteMagnitude),
                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                     attributes: [.font : font as Any ],
                                     context: nil).size
    }
    
    open override func drawText(in rect: CGRect) {
        
        guard let icon = icon else  {
            super.drawText(in: rect)
            return
        }
        
        //remove from view if it's present before adding it.
        iconView?.removeFromSuperview()
        iconView = UIImageView(image: icon)
        
        //calculate frame of the text based on content.
        guard let size = getAdjustedTextSize() else { return }
        
        var newRect = CGRect.zero
        guard let iconView = iconView else { return }
        
        /// calculate the icon y position
        let iconYPosition = (frame.height - iconView.frame.height) / 2
        let height = frame.height
        
        // set the frame positions according to text alignment and icon horizontal positions.
        switch iconPosition.horizontal {
        case .left:
            if textAlignment == .left {
                iconView.frame = iconView.frame.offsetBy(dx: padding, dy: iconYPosition)
                newRect = CGRect(x: iconView.frame.width + iconPadding + padding, y: 0, width: frame.width - (iconView.frame.width + iconPadding), height: height)
            }else if textAlignment == .right {
                iconView.frame = iconView.frame.offsetBy(dx: frame.width - size.width - iconPadding - iconView.frame.width - padding, dy: iconYPosition)
                newRect = CGRect(x: frame.width - size.width - padding , y: 0, width: size.width, height: height)
            }else if textAlignment == .center {
                iconView.frame = iconView.frame.offsetBy(dx: (frame.width - size.width) / 2 - iconPadding - iconView.frame.width, dy: iconYPosition)
                newRect = CGRect(x: (frame.width - size.width) / 2 , y: 0, width: size.width, height: height)
            }
        case .right:
            if textAlignment == .left {
                iconView.frame = iconView.frame.offsetBy(dx: size.width + iconPadding + padding, dy: iconYPosition)
                newRect = CGRect(x: padding, y: 0, width: size.width, height: height)
            }else if textAlignment == .right {
                iconView.frame = iconView.frame.offsetBy(dx: frame.width - iconView.frame.width - padding , dy: iconYPosition)
                newRect = CGRect(x: frame.width - size.width - iconView.frame.width - iconPadding - padding, y: 0, width: size.width, height: height)
            }else if textAlignment == .center {
                iconView.frame = iconView.frame.offsetBy(dx: frame.width / 2 + size.width / 2 + iconPadding, dy: iconYPosition)
                newRect = CGRect(x: (frame.width - size.width) / 2, y: 0, width: size.width, height: height)
            }
        }
        
        // set the frame positions of the icon vertically i.e., top, bottom or center
        switch iconPosition.vertical {
        case .top: iconView.frame.origin.y = (frame.height - size.height) / 2
            
        case .center: iconView.frame.origin.y = (frame.height - iconView.frame.height) / 2
            
        case .bottom: iconView.frame.origin.y = frame.height - (frame.height - size.height) / 2 - iconView.frame.size.height
        }
        
        addSubview(iconView)
        super.drawText(in: newRect)
        setup()
    }
    
    /// returns new size with updated vertical and horizantal padding.
    public override var intrinsicContentSize: CGSize {
        let superSize = getAdjustedTextSize() ?? super.intrinsicContentSize
        let iconWidth : CGFloat = iconView?.frame.width ?? 0.0
        let newWidth = superSize.width + iconPadding + iconWidth + (padding * 2) + (2 * horizontalPadding)
        let newHeight = superSize.height + (2 * verticalPadding)
        let size = CGSize(width: newWidth, height: newHeight)
        return size
    }
}

// MARK: - Reactive binding for label's text , vertical & horizontal padding.
extension Reactive where Base: CardPartIconLabel {
    
    public var labelText: Binder<String?>{
        return Binder(self.base) { (label, labelText) -> () in
            label.text = labelText
        }
    }
    
    public var verticalPadding: Binder<CGFloat> {
        return Binder(self.base) { (label, verticalPadding) -> () in
            label.verticalPadding = verticalPadding
        }
    }
    
    public var horizontalPadding: Binder<CGFloat> {
        return Binder(self.base) { (label, horizontalPadding) -> () in
            label.horizontalPadding = horizontalPadding
        }
    }
    
    public var iconView: Binder<UIImageView> {
        return Binder(self.base) { (imageView, iconView) -> () in
           imageView.iconView = iconView
        }
    }
    
    public var icon:Binder<UIImage?> {
        return Binder(self.base) { (image, icon) -> () in
            image.icon = icon
        }
    }
}

extension CardPartIconLabel {

    // create computed properties for extensions, we need a key to store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "CardPartIconLabel_ImageView"
    }

    fileprivate typealias Action = (() -> Void)?

    // set computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }

    // here we create tapGesture recognizer and store the closure user passed to us in the associated object.
    public func tapIconGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    // Every time the user taps on the UIImageView, this function gets called, which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        let iconViewFrame = (sender.view as? CardPartIconLabel)?.iconView?.frame
    
        guard let iconWidth = iconViewFrame?.size.width ,
            let originX = iconViewFrame?.origin.x,
            let action = self.tapGestureRecognizerAction else {
            return
        }
        
        if iconViewPosition.x <= ( iconWidth + originX ){
            action?()
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.iconViewPosition = touch.location(in: self)
    }
}
