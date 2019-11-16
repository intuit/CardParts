//
//  CardPartOrientedView.swift
//  CardParts
//
//  Created by Tumer, Deniz on 6/13/18.
//

import Foundation

/// Orientation
public enum Orientation {
    /// top
    case top
    /// bottom
    case bottom
}

/// CardPartOrientedView allows you to create an oriented list view of card part elements. This is similar to the `CardPartStackView` except that this view can orient elements to the top or bottom of the view. This is advantageous when you are using horizontal stack views and need elements to be oriented differently (top arranged or bottom arranged) relative to the other views in the horizontal stack view. To see a good example of this element please take a look at the example application.
///
/// The supported orientations are as follows:
///```
///public enum Orientation {
///    case top
///    case bottom
///}
///```
///
/// To create an oriented view you can use the following code:
///```
///let orientedView = CardPartOrientedView(cardParts: [<elements to list vertically>], orientation: .top)
///```
///
/// Add the above orientedView to any list of card parts or an existing stack view to orient your elements to the top or bottom of the enclosing view.
public class CardPartOrientedView: UIView, CardPartView {
    
    /// CardParts theme margins by default
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    private var orientation: Orientation
    private var cardParts: [CardPartView]
    
    /// Takes an array of `CardPartView`s and arranges them to `Orientation`
    ///
    /// - Parameters:
    ///   - cardParts: Array of `CardPartView`s
    ///   - orientation: `Orientation` of views
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
    
    /// Required init
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
