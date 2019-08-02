//
//  CardPartPillView.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 8/2/19.
//

import UIKit

public class CardPartPillLabel: UILabel, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    /// provides vertical and horizontal spacing
    public var verticalPadding:CGFloat = 2.0
    public var horizontalPadding:CGFloat = 2.0
    

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
