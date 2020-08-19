//
//  CardPartsTheme.swift
//  CardParts
//
//  Created by Kier, Tom on 12/7/17.
//

import Foundation

public protocol CardPartsTheme {
    
    var backgroundColor: UIColor { get set }
    
    var cardsViewContentInsetTop: CGFloat { get set }
    var cardsLineSpacing: CGFloat { get set }
    
    // CardCell
    var cardShadow: Bool { get set }
    var cardCellMargins: UIEdgeInsets { get set }
    var cardPartMargins: UIEdgeInsets { get set }
    var cardBackgroundColor: UIColor { get set }
    var cardBorderColor: UIColor { get set }
    var cardShadowColor: UIColor { get set }
    
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
    
    // CardPartAttributedTextView
    var attributedTextBackgroundColor: UIColor { get set }
    var smallAttributedTextFont: UIFont { get set }
    var smallAttributedTextColor: UIColor { get set }
    var normalAttributedTextFont: UIFont { get set }
    var normalAttributedTextColor: UIColor { get set }
    var titleAttributedTextFont: UIFont { get set }
    var titleAttributedTextColor: UIColor { get set }
    var headerAttributedTextFont: UIFont { get set }
    var headerAttributedTextColor: UIColor { get set }
    var detailAttributedTextFont: UIFont { get set }
    var detailAttributedTextColor: UIColor { get set }
    
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

public class CardPartsSystemTheme: CardPartsTheme {
    
    public var backgroundColor: UIColor = .SystemGroupedBackground
    
    public var cardsViewContentInsetTop: CGFloat = 0.0
    public var cardsLineSpacing: CGFloat = 12
    
    public var cardShadow: Bool = true
    public var cardCellMargins: UIEdgeInsets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 12.0, right: 12.0)
    public var cardPartMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
    
    // CardCell
    public var cardBackgroundColor: UIColor = .SecondarySystemGroupedBackground
    public var cardBorderColor: UIColor = .SystemGray6
    public var cardShadowColor: UIColor = .SystemGray6
    
    // CardPartSeparatorView
    public var separatorColor: UIColor = UIColor.color(221, green: 221, blue: 221)
    public var horizontalSeparatorMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
    
    // CardPartTextView
    public var smallTextFont: UIFont = .systemFont(ofSize: 10.0)
    public var smallTextColor: UIColor = .TertiaryLabel
    public var normalTextFont: UIFont = .systemFont(ofSize: 14.0)
    public var normalTextColor: UIColor = .TertiaryLabel
    public var titleTextFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
    public var titleTextColor: UIColor = .Label
    public var headerTextFont: UIFont = .systemFont(ofSize: CGFloat(FontSize.header.rawValue), weight: .black)
    public var headerTextColor: UIColor = .Label
    public var detailTextFont: UIFont = .systemFont(ofSize: 12.0)
    public var detailTextColor: UIColor = .TertiaryLabel
    
    // CardPartAttributedTextView
    public var smallAttributedTextFont: UIFont = .systemFont(ofSize: 10.0)
    public var smallAttributedTextColor: UIColor = .TertiaryLabel
    public var normalAttributedTextFont: UIFont = .systemFont(ofSize: 14.0)
    public var normalAttributedTextColor: UIColor = .Label
    public var titleAttributedTextFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
    public var titleAttributedTextColor: UIColor = .Label
    public var headerAttributedTextFont: UIFont = .systemFont(ofSize: CGFloat(FontSize.header.rawValue), weight: .black)
    public var headerAttributedTextColor: UIColor = .Label
    public var detailAttributedTextFont: UIFont = .systemFont(ofSize: 12.0)
    public var detailAttributedTextColor: UIColor = .TertiaryLabel
    public var attributedTextBackgroundColor: UIColor = .SecondarySystemGroupedBackground
    
    // CardPartTitleView
    public var titleFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
    public var titleColor: UIColor = .Label
    public var titleViewMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 10.0, right: 15.0)
    
    // CardPartButtonView
    public var buttonTitleFont: UIFont = .systemFont(ofSize: 17)
    public var buttonTitleColor: UIColor = .SystemBlue
    public var buttonCornerRadius: CGFloat = CGFloat(0.0)
    
    // CardPartBarView
    public var barBackgroundColor: UIColor = .TertiarySystemFill
    public var barColor: UIColor = .SystemTeal
    public var todayLineColor: UIColor = .SystemGray2
    public var barHeight: CGFloat = 13.5
    public var roundedCorners: Bool = false
    public var showTodayLine: Bool = true
    
    // CardPartTableView
    public var tableViewMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0)
    
    // CardPartTableViewCell and CardPartTitleDescriptionView
    public var leftTitleFont: UIFont = .systemFont(ofSize: 17.0)
    public var leftDescriptionFont: UIFont = .systemFont(ofSize: 12.0)
    public var rightTitleFont: UIFont = .systemFont(ofSize: 17.0)
    public var rightDescriptionFont: UIFont = .systemFont(ofSize: 12.0)
    public var leftTitleColor: UIColor = .Label
    public var leftDescriptionColor: UIColor = .SecondaryLabel
    public var rightTitleColor: UIColor = .Label
    public var rightDescriptionColor: UIColor = .SecondaryLabel
    public var secondaryTitlePosition : CardPartSecondaryTitleDescPosition = .right
    
    public init() {
        
    }
}

public class CardPartsCustomTheme: CardPartsTheme {
    
    public var backgroundColor: UIColor = UIColor.dynamicColor(light: .Gray6, dark: UIColor.colorFromHex(0x000013))
    
    public var cardsViewContentInsetTop: CGFloat = 0.0
    public var cardsLineSpacing: CGFloat = 12
    
    public var cardShadow: Bool = false
    public var cardCellMargins: UIEdgeInsets = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
    public var cardPartMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 28.0, bottom: 5.0, right: 28.0)
    
    // CardCell
    public var cardBackgroundColor: UIColor = UIColor.dynamicColor(light: UIColor.colorFromHex(0xfefffe), dark: UIColor.colorFromHex(0x0A172C))
    public var cardBorderColor: UIColor = .SystemGray6
    public var cardShadowColor: UIColor = .SystemGray6
    
    // CardPartSeparatorView
    public var separatorColor: UIColor = .cardPartSeparatorColor
    public var horizontalSeparatorMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)
    
    // CardPartTextView
    public var smallTextFont: UIFont = .cardPartsFont(.x_Small)
    public var smallTextColor: UIColor = .cardPartTextColor
    public var normalTextFont: UIFont = .cardPartsFont(.normal)
    public var normalTextColor: UIColor = .cardPartTextColor
    public var titleTextFont: UIFont = .cardPartsMediumFont(.medium)
    public var titleTextColor: UIColor = .cardPartTitleColor
    public var headerTextFont: UIFont = .cardPartsFontBlack(.header)
    public var headerTextColor: UIColor = .cardPartTitleColor
    public var detailTextFont: UIFont = .cardPartsFont(.small)
    public var detailTextColor: UIColor = .cardPartGrayTextColor
    
    // CardPartAttributedTextView
    public var smallAttributedTextFont: UIFont = .cardPartsFont(.x_Small)
    public var smallAttributedTextColor: UIColor = .cardPartTextColor
    public var normalAttributedTextFont: UIFont = .cardPartsFont(.normal)
    public var normalAttributedTextColor: UIColor = .cardPartTextColor
    public var titleAttributedTextFont: UIFont = .cardPartsMediumFont(.medium)
    public var titleAttributedTextColor: UIColor = .cardPartTitleColor
    public var headerAttributedTextFont: UIFont = .cardPartsFontBlack(.header)
    public var headerAttributedTextColor: UIColor = .cardPartTitleColor
    public var detailAttributedTextFont: UIFont = .cardPartsFont(.small)
    public var detailAttributedTextColor: UIColor = .cardPartGrayTextColor
    public var attributedTextBackgroundColor: UIColor = UIColor.dynamicColor(light: UIColor.colorFromHex(0xfefffe), dark: UIColor.colorFromHex(0x0A172C))
    
    // CardPartTitleView
    public var titleFont: UIFont = .cardPartsMediumFont(.medium)
    public var titleColor: UIColor = .cardPartTitleColor
    public var titleViewMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 28.0, bottom: 10.0, right: 28.0)
    
    // CardPartButtonView
    public var buttonTitleFont: UIFont = .cardPartsFont(.large)
    public var buttonTitleColor: UIColor = .cardPartBlueColor
    public var buttonCornerRadius: CGFloat = .zero
    
    // CardPartBarView
    public var barBackgroundColor: UIColor = .TertiarySystemFill
    public var barColor: UIColor = .cardPartHeaderBlueColor
    public var todayLineColor: UIColor = .SystemFill
    public var barHeight: CGFloat = 20.0
    public var roundedCorners: Bool = true
    public var showTodayLine: Bool = false
    
    // CardPartTableView
    public var tableViewMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 28.0, bottom: 0.0, right: 28.0)
    
    // CardPartTableViewCell and CardPartTitleDescriptionView
    public var leftTitleFont: UIFont = .cardPartsFont(.large)
    public var leftDescriptionFont: UIFont = .cardPartsFont(.small)
    public var rightTitleFont: UIFont = .cardPartsFont(.large)
    public var rightDescriptionFont: UIFont = .cardPartsFont(.small)
    public var leftTitleColor: UIColor = .cardPartTitleColor
    public var leftDescriptionColor: UIColor = .cardPartGrayTextColor
    public var rightTitleColor: UIColor = .cardPartTitleColor
    public var rightDescriptionColor: UIColor = .cardPartGrayTextColor
    public var secondaryTitlePosition : CardPartSecondaryTitleDescPosition = .center(amount: 0.0)
    
    public init() {
        
    }
}
