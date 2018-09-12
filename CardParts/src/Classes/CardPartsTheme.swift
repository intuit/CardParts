//
//  CardPartsTheme.swift
//  CardParts
//
//  Created by Kier, Tom on 12/7/17.
//

import Foundation

public protocol CardPartsTheme {
    
    var cardsViewContentInsetTop: CGFloat { get set }
    var cardsLineSpacing: CGFloat { get set }

    var cardShadow: Bool { get set }
    var cardCellMargins: UIEdgeInsets { get set }
    var cardPartMargins: UIEdgeInsets { get set }
    
    // CardPartSeparatorView and CardPartVerticalSeparatorView
    var separatorColor: UIColor { get set }
    var horizontalSeparatorMargins: UIEdgeInsets { get set }
    
    // CardPartTextView
    var smallTextFont: UIFont { get set }
    var smallTextColor: UIColor { get set }
    var normalTextFont: UIFont { get set }
    var normalTextColor: UIColor { get set }
    var titleTextFont: UIFont { get set }
    var titleTextColor: UIColor { get set }
    var headerTextFont: UIFont { get set }
    var headerTextColor: UIColor { get set }
    var detailTextFont: UIFont { get set }
    var detailTextColor: UIColor { get set }
    
    // CardPartTitleView
    var titleFont: UIFont { get set }
    var titleColor: UIColor { get set }
    var titleViewMargins: UIEdgeInsets { get set }

    // CardPartButtonView
    var buttonTitleFont: UIFont { get set }
    var buttonTitleColor: UIColor { get set }
    var buttonCornerRadius: CGFloat { get set }

    // CardPartBarView
    var barBackgroundColor: UIColor { get set }
    var barHeight: CGFloat { get set }
    var barColor: UIColor { get set }
    var todayLineColor: UIColor { get set }
    var roundedCorners: Bool { get set }
    var showTodayLine: Bool { get set }

    // CardPartTableView and CardPartCollectionView
    var tableViewMargins: UIEdgeInsets { get set }

    // CardPartTableViewCell and CardPartTitleDescriptionView
    var leftTitleFont: UIFont { get set }
    var leftDescriptionFont: UIFont { get set }
    var rightTitleFont: UIFont { get set }
    var rightDescriptionFont: UIFont { get set }
    var leftTitleColor: UIColor { get set }
    var leftDescriptionColor: UIColor { get set }
    var rightTitleColor: UIColor { get set }
    var rightDescriptionColor: UIColor { get set }
    var secondaryTitlePosition : CardPartSecondaryTitleDescPosition { get set }

}

extension CardPartsTheme {
    public func apply() {
        CardParts.theme = self
    }
}

public class CardPartsMintTheme: CardPartsTheme {
    
    public var cardsViewContentInsetTop: CGFloat = 0.0
    public var cardsLineSpacing: CGFloat = 12
    
    public var cardShadow: Bool = true
    public var cardCellMargins: UIEdgeInsets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 12.0, right: 12.0)
    public var cardPartMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
    
    // CardPartSeparatorView
    public var separatorColor: UIColor = UIColor.color(221, green: 221, blue: 221)
    public var horizontalSeparatorMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
    
    // CardPartTextView
    public var smallTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(10))!
    public var smallTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    public var normalTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(14))!
    public var normalTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    public var titleTextFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))!
    public var titleTextColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    public var headerTextFont: UIFont = UIFont.turboGenericFontBlack(.header)
    public var headerTextColor: UIColor = UIColor.turboCardPartTitleColor
    public var detailTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    public var detailTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    
    // CardPartTitleView
    public var titleFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))!
    public var titleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    public var titleViewMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 10.0, right: 15.0)
    
    // CardPartButtonView
    public var buttonTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    public var buttonTitleColor: UIColor = UIColor(red: 69.0/255.0, green: 202.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    public var buttonCornerRadius: CGFloat = CGFloat(0.0)
    
    // CardPartBarView
    public var barBackgroundColor: UIColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    public var barColor: UIColor = UIColor.turboHeaderBlueColor
    public var todayLineColor: UIColor = UIColor.Gray8
    public var barHeight: CGFloat = 13.5
    public var roundedCorners: Bool = false
    public var showTodayLine: Bool = true
    
    // CardPartTableView
    public var tableViewMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0)
    
    // CardPartTableViewCell and CardPartTitleDescriptionView
    public var leftTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    public var leftDescriptionFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    public var rightTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    public var rightDescriptionFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    public var leftTitleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    public var leftDescriptionColor: UIColor = UIColor.color(169, green: 169, blue: 169)
    public var rightTitleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    public var rightDescriptionColor: UIColor = UIColor.color(169, green: 169, blue: 169)
    public var secondaryTitlePosition : CardPartSecondaryTitleDescPosition = .right
    
    public init() {
        
    }
}


public class CardPartsTurboTheme: CardPartsTheme {

    public var cardsViewContentInsetTop: CGFloat = 0.0
    public var cardsLineSpacing: CGFloat = 12

    public var cardShadow: Bool = false
    public var cardCellMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    public var cardPartMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 28.0, bottom: 5.0, right: 28.0)

    // CardPartSeparatorView
    public var separatorColor: UIColor = UIColor.turboSeperatorColor
    public var horizontalSeparatorMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)

    // CardPartTextView
    public var smallTextFont: UIFont = UIFont.turboGenericFont(.x_Small)
    public var smallTextColor: UIColor = UIColor.turboCardPartTextColor
    public var normalTextFont: UIFont = UIFont.turboGenericFont(.normal)
    public var normalTextColor: UIColor = UIColor.turboCardPartTextColor
    public var titleTextFont: UIFont = UIFont.turboGenericMediumFont(.medium)
    public var titleTextColor: UIColor = UIColor.turboCardPartTitleColor
    public var headerTextFont: UIFont = UIFont.turboGenericFontBlack(.header)
    public var headerTextColor: UIColor = UIColor.turboCardPartTitleColor
    public var detailTextFont: UIFont = UIFont.turboGenericFont(.small)
    public var detailTextColor: UIColor = UIColor.turboCardPartTextColor
    
    // CardPartTitleView
    public var titleFont: UIFont = UIFont.turboGenericMediumFont(.medium)
    public var titleColor: UIColor = UIColor.turboCardPartTitleColor
    public var titleViewMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 28.0, bottom: 10.0, right: 28.0)

    // CardPartButtonView
    public var buttonTitleFont: UIFont = UIFont.turboGenericFont(.large)
    public var buttonTitleColor: UIColor = UIColor.turboBlueColor
    public var buttonCornerRadius: CGFloat = CGFloat(0.0)

    // CardPartBarView
    public var barBackgroundColor: UIColor = UIColor.turboSeperatorGray
    public var barColor: UIColor = UIColor.turboHeaderBlueColor
    public var todayLineColor: UIColor = UIColor.Gray8
    public var barHeight: CGFloat = 20.0
    public var roundedCorners: Bool = true
    public var showTodayLine: Bool = false

    // CardPartTableView
    public var tableViewMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 28.0, bottom: 0.0, right: 28.0)

    // CardPartTableViewCell and CardPartTitleDescriptionView
    public var leftTitleFont: UIFont = UIFont.turboGenericFont(.large)
    public var leftDescriptionFont: UIFont = UIFont.turboGenericFont(.small)
    public var rightTitleFont: UIFont = UIFont.turboGenericFont(.large)
    public var rightDescriptionFont: UIFont = UIFont.turboGenericFont(.small)
    public var leftTitleColor: UIColor = UIColor.turboCardPartTitleColor
    public var leftDescriptionColor: UIColor = UIColor.turboGenericGreyTextColor
    public var rightTitleColor: UIColor = UIColor.turboCardPartTitleColor
    public var rightDescriptionColor: UIColor = UIColor.turboGenericGreyTextColor
    public var secondaryTitlePosition : CardPartSecondaryTitleDescPosition = .center(amount: 0.0)

    public init() {
        
    }

}

