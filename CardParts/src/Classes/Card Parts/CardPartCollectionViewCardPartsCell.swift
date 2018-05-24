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
    private var constraintsAdded = false

    var stackView : UIStackView
    private var cardParts:[CardPartView] = []

    override public init(frame: CGRect) {

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 0

        super.init(frame: .zero)

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }

        contentView.addSubview(stackView)

        setNeedsUpdateConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func updateConstraints() {

        if !constraintsAdded {
            setupContraints()
        }

        super.updateConstraints()
    }

    func setupContraints() {

        constraintsAdded = true

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics: nil, views: ["stackView" : stackView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: ["stackView" : stackView]))
    }

    public func setupCardParts(_ cardParts:[CardPartView]) {

        self.cardParts = cardParts

        for cardPart in cardParts {

            if cardPart.margins.top > 0  {
                let spacer = CardPartSpacerView(height: cardPart.margins.top)
                stackView.addArrangedSubview(spacer)
                stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[spacer]|", options: [], metrics: nil, views: ["spacer" : spacer]))
            }

            if let _ = cardPart.viewController {
                // TODO add support for cardParts implemented as view controllers
                print("Viewcontroller card parts not supported in collection view cells")
            } else {
                stackView.addArrangedSubview(cardPart.view)
            }

            let metrics = ["leftMargin" : cardPart.margins.left - 28, "rightMargin" : cardPart.margins.right - 28]
            stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[cardPartView]-rightMargin-|", options: [], metrics: metrics, views: ["cardPartView" : cardPart.view]))

            if cardPart.margins.bottom > 0 {
                let spacer = CardPartSpacerView(height: cardPart.margins.bottom)
                stackView.addArrangedSubview(spacer)
                stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[spacer]|", options: [], metrics: nil, views: ["spacer" : spacer]))
            }

        }
    }
}
