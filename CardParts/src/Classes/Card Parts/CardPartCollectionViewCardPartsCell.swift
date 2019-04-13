//
//  CardPartCollectionViewCardPartsCell.swift
//  CardParts
//
//  Created by Roossin, Chase on 3/7/18.
//

import Foundation

open class CardPartCollectionViewCardPartsCell : UICollectionViewCell {

    private var rightTopConstraint: NSLayoutConstraint!
    private var leftTopConstraint: NSLayoutConstraint!
    
    private var cardParts:[CardPartView] = []

    override public init(frame: CGRect) {

        super.init(frame: .zero)

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }

        setNeedsUpdateConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupCardParts(_ cardParts:[CardPartView]) {

        self.cardParts = cardParts
        
        var prevCardPart: UIView = contentView
        var padding: CGFloat = 0
        
        for cardPart in cardParts {
            cardPart.view.translatesAutoresizingMaskIntoConstraints = false
            padding += cardPart.margins.top
            
            if let _ = cardPart.viewController {
                // TODO add support for cardParts implemented as view controllers
                print("Viewcontroller card parts not supported in collection view cells")
            } else {
                contentView.addSubview(cardPart.view)
            }
            
            let metrics = ["leftMargin" : cardPart.margins.left - 28, "rightMargin" : cardPart.margins.right - 28]
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[cardPartView]-rightMargin-|", options: [], metrics: metrics, views: ["cardPartView" : cardPart.view!]))
            if prevCardPart == contentView {
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[cardPartView]", options: [], metrics: ["padding" : padding], views: ["cardPartView" : cardPart.view!]))
            } else {
                contentView.addConstraints([NSLayoutConstraint(item: cardPart.view!, attribute: .top, relatedBy: .equal, toItem: prevCardPart, attribute: .bottom, multiplier: 1.0, constant: padding)])
            }
            
            prevCardPart = cardPart.view
            padding = cardPart.margins.bottom
            
        }
    }
}
