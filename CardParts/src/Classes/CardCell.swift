//
//  CardCell.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/17/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit

open class CardCell : UICollectionViewCell {
    
    var cardContentView : UIView
    var cardContentConstraints = [NSLayoutConstraint]()
    var topBottomMarginConstraints = [NSLayoutConstraint]()
    
    private var currentSize = CGSize.zero
    private var gradientLayer = CAGradientLayer()
    
    private var borderColor = CardParts.theme.cardBorderColor {
        didSet {
            contentView.layer.borderColor = borderColor.cgColor(with: traitCollection)
        }
    }
    private var shadowColor = CardParts.theme.cardShadowColor {
        didSet {
            contentView.layer.shadowColor = shadowColor.cgColor(with: traitCollection)
        }
    }

    override init(frame: CGRect) {
        
        cardContentView = UIView()
        cardContentView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = CardParts.theme.cardBackgroundColor
        contentView.layer.borderColor = borderColor.cgColor(with: traitCollection)
        contentView.layer.borderWidth = 0.5
        if CardParts.theme.cardShadow {
            contentView.layer.shadowColor = shadowColor.cgColor(with: traitCollection)
            contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
            contentView.layer.shadowRadius = 1.0
            contentView.layer.shadowOpacity = 0.9
        }
        
        contentView.addSubview(cardContentView)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cardContentView]|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: ["cardContentView" : cardContentView]))
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        gestureRecognizers?.forEach { removeGestureRecognizer($0) }
    }
    
    override open var bounds: CGRect {
        didSet {
            contentView.frame = bounds
            gradientLayer.frame = self.bounds
        }
    }
    
    var gradientColors: [UIColor] = [] {
        didSet {
            gradientLayer.colors = gradientColors.map({ (color) -> CGColor in
                return color.cgColor
            })
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0.0
        }
    }
    
    var gradientAngle: Float = 0 {
        didSet {
            let alpha: Float = gradientAngle / 360
            let startPointX = powf(
                sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
                2
            )
            let startPointY = powf(
                sinf(2 * Float.pi * ((alpha + 0) / 2)),
                2
            )
            let endPointX = powf(
                sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
                2
            )
            let endPointY = powf(
                sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
                2
            )
            gradientLayer.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
            gradientLayer.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        }
    }
    
    override open func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let desiredHeight: CGFloat = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let desiredWidth: CGFloat = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width

        if currentSize.height != desiredHeight || currentSize.width != desiredWidth || currentSize != layoutAttributes.size {
            let attr = super.preferredLayoutAttributesFitting(layoutAttributes)
            attr.frame.size.height = desiredHeight
            attr.frame.size.width = desiredWidth
            currentSize = attr.frame.size
            return attr
        }
        return layoutAttributes
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        contentView.layer.borderColor = borderColor.cgColor(with: traitCollection)
        contentView.layer.shadowColor = shadowColor.cgColor(with: traitCollection)
    }
    
    func requiresNoTopBottomMargins(_ noTopBottomMargins: Bool) {
        
        contentView.removeConstraints(topBottomMarginConstraints)
        
        if noTopBottomMargins {
            topBottomMarginConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[cardContentView]|",
                                                                        options: [],
                                                                        metrics: nil,
                                                                        views: ["cardContentView" : cardContentView])
        } else {
            let metrics = ["topInset": CardParts.theme.cardCellMargins.top, "bottomInset": CardParts.theme.cardCellMargins.bottom]
            topBottomMarginConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-topInset-[cardContentView]-bottomInset-|",
                                                                        options: [],
                                                                        metrics: metrics,
                                                                        views: ["cardContentView" : cardContentView])
        }
        
        contentView.addConstraints(topBottomMarginConstraints)
        setNeedsLayout()
    }
    
    func requiresTransparentCard(transparentCard: Bool) {
        if transparentCard {
            contentView.backgroundColor = UIColor.clear
            self.borderColor = UIColor.clear
            contentView.layer.borderWidth = 0.0
            self.shadowColor = UIColor.clear
            contentView.layer.shadowOffset = CGSize.zero
            contentView.layer.shadowRadius = 0.0
            contentView.layer.shadowOpacity = 0.0
        } else {
            contentView.backgroundColor = CardParts.theme.cardBackgroundColor
            contentView.layer.borderColor = borderColor.cgColor(with: traitCollection)
            contentView.layer.borderWidth = 0.5
            if CardParts.theme.cardShadow {
                contentView.layer.shadowColor = shadowColor.cgColor(with: traitCollection)
                contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
                contentView.layer.shadowRadius = 1.0
                contentView.layer.shadowOpacity = 0.9
            }
        }
    }
    
    func addShadowToCard(shadowRadius: CGFloat = 8.0, shadowOpacity: Float = 0.7, shadowColor: UIColor = UIColor.Gray2, shadowOffset: CGSize = CGSize(width: 0, height: 5)) {
        self.shadowColor = shadowColor
        contentView.layer.shadowOffset = shadowOffset
        contentView.layer.shadowRadius = shadowRadius
        contentView.layer.shadowOpacity = shadowOpacity
    }
    
    func setCornerRadius(radius: CGFloat) {
        contentView.layer.cornerRadius = radius
        gradientLayer.cornerRadius = radius
    }
    
    func addBorderToCard(borderWidth: CGFloat = 0.5, borderColor: UIColor = UIColor.SystemGray6) {
        self.borderColor = borderColor
        contentView.layer.borderWidth = borderWidth
    }
    
    func addLongGestureRecognizer(minimumPressDuration: CFTimeInterval, delegate: CardPartsLongPressGestureRecognizerDelegate) {
        let longGesture = UILongPressGestureRecognizer(target: delegate, action: #selector(CardPartsLongPressGestureRecognizerDelegate.didLongPress(_:)))
        longGesture.minimumPressDuration = minimumPressDuration
        self.addGestureRecognizer(longGesture)
    }
    
    override open func updateConstraints() {
        super.updateConstraints()
    }
}

