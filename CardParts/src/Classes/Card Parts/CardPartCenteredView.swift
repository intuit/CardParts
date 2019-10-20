//
//  CardPartCenteredView.swift
//  CardParts
//
//  Created by Tumer, Deniz on 6/20/18.
//

import Foundation

/// CardPartCenteredView is a CardPart that fits a centered card part proportionally on the phone screen while allowing a left and right side card part to scale appropriately.
///
/// A CardPartCenteredView can take in any card part that conforms to CardPartView as the left, center, and right components. To see a graphical example of the centered card part please look at the example application packaged with this cocoapod.
///
/// Example:
///```
///class TestCardController : CardPartsViewController {
///    override func viewDidLoad() {
///        super.viewDidLoad()
///
///        let rightTextCardPart = CardPartTextView(type: .normal)
///        rightTextCardPart.text = "Right text in a label"
///
///        let centeredSeparator = CardPartVerticalSeparator()
///
///        let leftTextCardPart = CardPartTextView(type: .normal)
///        leftTextCardPart.text = "Left text in a label"
///
///        let centeredCardPart = CardPartCenteredView(leftView: leftTextCardPart, centeredView: centeredSeparator, rightView: rightTextCardPart)
///
///        setupCardParts([centeredCardPart])
///    }
///}
///```
public class CardPartCenteredView: UIView, CardPartView {
    
    /// `margins` set by CardParts Theme by default
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
