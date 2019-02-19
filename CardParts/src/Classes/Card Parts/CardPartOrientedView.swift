//
//  CardPartOrientedView.swift
//  CardParts
//
//  Created by Tumer, Deniz on 6/13/18.
//

import Foundation

public enum Orientation {
    case top
    case bottom
}

/**
 * This card part allows for oriented elements. It takes a list of card part views that can be oriented towards the top or bottom of a view.
 * Although a stack view has the power to orient elements this oriented card part goes beyond the alignment and distribution types that a stack view can offer.
 */
public class CardPartOrientedView: UIView, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    private var orientation: Orientation
    private var cardParts: [CardPartView]
    
    public init(cardParts: [CardPartView], orientation: Orientation) {
        self.orientation = orientation
        self.cardParts = cardParts
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        // add spacer to subviews
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.addSubview(spacer)
        
        var prevCardPart: CardPartView = self
        
        // go through each card part and link the top margins to the bottom of the previous card part
        for (ndx, cardPart) in cardParts.enumerated() {
            cardPart.view.translatesAutoresizingMaskIntoConstraints = false
            cardPart.view.bounds = CGRect.zero
            self.addSubview(cardPart.view)
            
            // if we're not the first one add constraints from the current card part to the previous one
            if ndx != 0 {
                let constraints = [
                    NSLayoutConstraint(item: cardPart, attribute: .top, relatedBy: .equal, toItem: prevCardPart, attribute: .bottom, multiplier: 1, constant: cardPart.margins.top)
                ]
                
                self.addConstraints(constraints)
                cardPart.view.setContentHuggingPriority(.defaultLow, for: .vertical)
            }
            
            var constraints = [
                NSLayoutConstraint(item: cardPart, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: cardPart, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            ]
            
            // if ndx is 0 then add constraint for top of card part to top of view
            // only add it if we're orienting towards the top
            if ndx == 0 && orientation == .top {
                constraints.append(NSLayoutConstraint(item: cardPart, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
            }
            // if we're on the last element set the bottom of that element to the view
            //only set bottom constraint if the orientation is bottom
            else if ndx == cardParts.count - 1 && orientation == .bottom {
                constraints.append(NSLayoutConstraint(item: cardPart, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
            }
            
            addSpacerConstraints(ndx: ndx, spacer: spacer, cardPart: cardPart)
            self.addConstraints(constraints)
            
            prevCardPart = cardPart
        }
        
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }
    
    // add spacer constraints
    private func addSpacerConstraints(ndx: Int, spacer: UIView, cardPart: CardPartView) {
        var constraints = [NSLayoutConstraint]()
        
        // if top element and the orientation is set to bottom
        if ndx == 0 && orientation == .bottom {
            constraints.append(NSLayoutConstraint(item: spacer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: spacer, attribute: .bottom, relatedBy: .equal, toItem: cardPart, attribute: .top, multiplier: 1, constant: 0))
        }
        else if ndx == cardParts.count - 1 && orientation == .top {
            constraints.append(NSLayoutConstraint(item: spacer, attribute: .top, relatedBy: .equal, toItem: cardPart, attribute: .bottom, multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: spacer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        }
        
        self.addConstraints(constraints)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
