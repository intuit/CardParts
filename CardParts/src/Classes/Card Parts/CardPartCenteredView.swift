//
//  CardPartCenteredView.swift
//  CardParts
//
//  Created by Tumer, Deniz on 6/20/18.
//

import Foundation

public class CardPartCenteredView: UIView, CardPartView {
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    public init(leftView: CardPartView, centeredView: CardPartView, rightView: CardPartView) {
        super.init(frame: CGRect.zero)
        
        // add subviews
        translatesAutoresizingMaskIntoConstraints = false
        leftView.view.translatesAutoresizingMaskIntoConstraints = false
        rightView.view.translatesAutoresizingMaskIntoConstraints = false
        centeredView.view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftView.view)
        self.addSubview(rightView.view)
        self.addSubview(centeredView.view)
        
        let constraints = [
            // centered view constraints
            NSLayoutConstraint(item: centeredView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: centeredView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: centeredView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            
            // left view constraints
            NSLayoutConstraint(item: leftView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: leftView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: leftView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: leftView, attribute: .trailing, relatedBy: .equal, toItem: centeredView, attribute: .leading, multiplier: 1, constant: -1 * leftView.margins.right),
            
            // right view constraints
            NSLayoutConstraint(item: rightView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rightView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rightView, attribute: .leading, relatedBy: .equal, toItem: centeredView, attribute: .trailing, multiplier: 1, constant: rightView.margins.left),
            NSLayoutConstraint(item: rightView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        ]
        
        self.addConstraints(constraints)
        
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
