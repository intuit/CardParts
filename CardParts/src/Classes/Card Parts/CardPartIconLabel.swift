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
    
    fileprivate var iconView: UIImageView?
    
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
                newRect = CGRect(x: 10, y: 0, width: size.width, height: height)
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
}
