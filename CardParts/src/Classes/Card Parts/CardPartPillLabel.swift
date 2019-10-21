//
//  CardPartPillView.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 8/2/19.
//  Copyright © 2019 Intuit. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

/// CardPartPillLabel provides you the rounded corners, text aligned being at the center along with vertical and horizontal padding capability.
///```
///var verticalPadding:CGFloat
///var horizontalPadding:CGFloat
///```
/// ![Pill Label examples](https://raw.githubusercontent.com/Intuit/CardParts/master/images/pillLabels.png)
public class CardPartPillLabel: UILabel, CardPartView {
    
    /// CardPart theme margins by default
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    // MARK: - Reactive Properties
    
    /// Text in label
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
    
    // MARK: - 

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.layer.cornerRadius = frame.height / 2
        self.clipsToBounds = true
        self.textAlignment = .center
    }
    
    /// returns new size with updated vertical and horizantal padding.
    public override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        let newWidth = superSize.width + superSize.height + (2 * horizontalPadding)
        let newHeight = superSize.height + (2 * verticalPadding)
        let size = CGSize(width: newWidth, height: newHeight)
        return size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

// MARK: - Reactive binding for label's text , vertical & horizontal padding.
extension Reactive where Base: CardPartPillLabel {
    
    /// Updates labe;'s text
    public var labelText: Binder<String?>{
        return Binder(self.base) { (label, labelText) -> () in
            label.text = labelText
        }
    }
    
    /// Updates label's verticalPadding
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
}
