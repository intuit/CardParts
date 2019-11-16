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

/// CardPartIconLabel provides the capability to add images in either directions supporting left , right and center text alignments.
///```
///let iconLabel = CardPartIconLabel()
///iconLabel.verticalPadding = 10
///iconLabel.horizontalPadding = 10
///iconLabel.backgroundColor = UIColor.blue
///iconLabel.font = UIFont.systemFont(ofSize: 12)
///iconLabel.textColor = UIColor.black
///iconLabel.numberOfLines = 0
///iconLabel.iconPadding = 5
///iconLabel.icon = UIImage(named: "cardIcon")
///```
/// ![Icon Label Example](https://raw.githubusercontent.com/Intuit/CardParts/master/images/cardPartIconLabel.png)
public class CardPartIconLabel: UILabel, CardPartView {

    /// Horizontal position
    public enum HorizontalPosition {
        /// left
        case left
        /// right
        case right
    }

    /// Vertical position
    public enum VerticalPosition {
        /// top
        case top
        /// center
        case center
        /// bottom
        case bottom
    }

    // MARK: - Reactive Properties

    /// label for icon
    public var labelText: String? {
        didSet {
            guard let text = labelText else { return }
            self.text = text
        }
    }
    /// verticalPadding - 2.0 by default
    public var verticalPadding:CGFloat = 2.0
    /// horizontalPadding - 2.0 by default
    public var horizontalPadding:CGFloat = 2.0

    /// icon imageView
    public var iconView: UIImageView? {
        didSet {
            guard let image = iconView?.image else { return }
            self.icon = image
        }
    }

    // MARK: Normal Properties

    /// CardParts theme margins by default
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins

    /// padding - 10.0 by default
    public var padding:CGFloat = 10.0

    fileprivate var iconViewPosition:CGPoint = CGPoint.zero

    /// Horizontal and vertical position
    public typealias Position = (horizontal: CardPartIconLabel.HorizontalPosition, vertical: CardPartIconLabel.VerticalPosition)
    /// defaults to (`.left`, `.top`)
    open var iconPosition: Position = (.left , .top)

    /// additional spacing between text and the image
    public var iconPadding: CGFloat = 0

    /// icon image
    public var icon:UIImage? {
        didSet {
            if icon == nil {
                iconView?.removeFromSuperview()
            }
            setNeedsDisplay()
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

    /// Draws label text specially within the frame with icon
    open override func drawText(in rect: CGRect) {
        guard let text = text as NSString? else { return }

        guard let icon = icon else  {
            super.drawText(in: rect)
            return
        }

        //remove from view if it's present before adding it.
        iconView?.removeFromSuperview()
        iconView = UIImageView(image: icon)

        //calculate frame of the text based on content.
        let size = text.boundingRect(with: CGSize(width: frame.width - icon.size.width - iconPadding, height: .greatestFiniteMagnitude),
                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                     attributes: [.font : font as Any ],
                                     context: nil).size

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
                newRect = CGRect(x: frame.width - size.width - iconPadding - padding , y: 0, width: size.width + iconPadding, height: height)
            }else if textAlignment == .center {
                iconView.frame = iconView.frame.offsetBy(dx: (frame.width - size.width) / 2 - iconPadding - iconView.frame.width, dy: iconYPosition)
                newRect = CGRect(x: (frame.width - size.width) / 2 , y: 0, width: size.width + iconPadding, height: height)
            }
        case .right:
            if textAlignment == .left {
                iconView.frame = iconView.frame.offsetBy(dx: size.width + iconPadding + padding, dy: iconYPosition)
                newRect = CGRect(x: 0, y: 0, width: size.width, height: height)
            }else if textAlignment == .right {
                iconView.frame = iconView.frame.offsetBy(dx: frame.width - iconView.frame.width - padding , dy: iconYPosition)
                newRect = CGRect(x: frame.width - size.width - iconView.frame.width - iconPadding - 2 * padding, y: 0, width: size.width + iconPadding, height: height)
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
        let superSize = super.intrinsicContentSize
        let newWidth = superSize.width + superSize.height + (2 * horizontalPadding)
        let newHeight = superSize.height + (2 * verticalPadding)
        let size = CGSize(width: newWidth, height: newHeight)
        return size
    }
}

// MARK: - Reactive binding for label's text , vertical & horizontal padding.
extension Reactive where Base: CardPartIconLabel {

    /// Updates label's text
    public var labelText: Binder<String?>{
        return Binder(self.base) { (label, labelText) -> () in
            label.text = labelText
        }
    }

    /// Updates label's vertical padding
    public var verticalPadding: Binder<CGFloat> {
        return Binder(self.base) { (label, verticalPadding) -> () in
            label.verticalPadding = verticalPadding
        }
    }

    /// Updates label's horizontalPadding
    public var horizontalPadding: Binder<CGFloat> {
        return Binder(self.base) { (label, horizontalPadding) -> () in
            label.horizontalPadding = horizontalPadding
        }
    }

    /// Updates imageView/s iconView
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

    /// here we create tapGesture recognizer and store the closure user passed to us in the associated object.
    public func tapIconGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    /// Every time the user taps on the UIImageView, this function gets called, which triggers the closure we stored
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

    /// Proxy touches location to icon position to help determine if action should be called
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.iconViewPosition = touch.location(in: self)
    }
}
