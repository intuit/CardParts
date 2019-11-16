//
//  CardPartsTheme.swift
//  CardParts
//
//  Created by Kier, Tom on 12/7/17.
//

import Foundation

///Out of the box we support 2 themes: Mint and Turbo. These are the 2 Intuit app's that are currently built on top of CardParts. As you can find in the file CardPartsTheme.swift we have a protocol called CardPartsTheme. You may create a class that conforms to CardPartsTheme and set all properties in order to theme CardParts however you may like.
/// <h3>Applying a theme</h3>
///Generate a class as follows:
///```
///public class YourCardPartTheme: CardPartsTheme {
///    ...
///}
///```
///And then in your `AppDelegate` call `YourCardPartTheme().apply()` to apply your theme.
public protocol CardPartsTheme {
    
    /// Top inset used in `CardsViewController`
    var cardsViewContentInsetTop: CGFloat { get set }
    /// Layout.minimumLineSpacing in `cardsLineSpacing`
    var cardsLineSpacing: CGFloat { get set }

    /// Shadow toogle for `CardCell`
    var cardShadow: Bool { get set }
    /// `CardCell` default insets
    var cardCellMargins: UIEdgeInsets { get set }
    /// Default insets used in most CardPart*Views, ex: `CardPartBarView`
    var cardPartMargins: UIEdgeInsets { get set }
    
    // MARK: CardPartSeparatorView and CardPartVerticalSeparatorView
    
    /// BackgroundColor for `CardPartSeparatorView`
    var separatorColor: UIColor { get set }
    /// Insets for `CardPartSeparatorView`
    var horizontalSeparatorMargins: UIEdgeInsets { get set }
    
    // MARK: CardPartTextView
    
    /// Applied in `CardPartTextView` for `.small` type
    var smallTextFont: UIFont { get set }
    /// Applied in `CardPartTextView` for `.small` type
    var smallTextColor: UIColor { get set }
    /// Applied in `CardPartTextView` for `.normal` type
    var normalTextFont: UIFont { get set }
    /// Applied in `CardPartTextView` for `.normal` type
    var normalTextColor: UIColor { get set }
    /// Applied in `CardPartTextView` for `.title` type
    var titleTextFont: UIFont { get set }
    /// Applied in `CardPartTextView` for `.title` type
    var titleTextColor: UIColor { get set }
    /// Applied in `CardPartTextView` for `.header` type
    var headerTextFont: UIFont { get set }
    /// Applied in `CardPartTextView` for `.header` type
    var headerTextColor: UIColor { get set }
    /// Applied in `CardPartTextView` for `.detail` type
    var detailTextFont: UIFont { get set }
    /// Applied in `CardPartTextView` for `.detail` type
    var detailTextColor: UIColor { get set }
    
    // MARK: CardPartTitleView
    
    /// Default applied in `CardPartTitleView`
    var titleFont: UIFont { get set }
    /// Default applied in `CardPartTitleView`
    var titleColor: UIColor { get set }
    /// Default applied in `CardPartTitleView`
    var titleViewMargins: UIEdgeInsets { get set }

    // MARK: CardPartButtonView
    
    /// Default applied in `CardPartButtonView`
    var buttonTitleFont: UIFont { get set }
    /// Default applied in `CardPartButtonView`
    var buttonTitleColor: UIColor { get set }
    /// Default applied in `CardPartButtonView`
    var buttonCornerRadius: CGFloat { get set }

    // MARK: CardPartBarView
    
    /// BackgroundColor in `CardPartBarView`
    var barBackgroundColor: UIColor { get set }
    /// Default in `CardPartBarView`
    var barHeight: CGFloat { get set }
    /// Default in `CardPartBarView`
    var barColor: UIColor { get set }
    /// BackgroundColor in `CardPartBarView`
    var todayLineColor: UIColor { get set }
    /// BarLayer corner radius in `CardPartBarView`
    var roundedCorners: Bool { get set }
    /// Default in `CardPartBarView`
    var showTodayLine: Bool { get set }

    // MARK: CardPartTableView and CardPartCollectionView
    
    /// Default for `CardPartTableView` and `CardPartCollectionView`
    var tableViewMargins: UIEdgeInsets { get set }

    // MARK: CardPartTableViewCell and CardPartTitleDescriptionView
    
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var leftTitleFont: UIFont { get set }
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var leftDescriptionFont: UIFont { get set }
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var rightTitleFont: UIFont { get set }
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var rightDescriptionFont: UIFont { get set }
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var leftTitleColor: UIColor { get set }
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var leftDescriptionColor: UIColor { get set }
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var rightTitleColor: UIColor { get set }
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var rightDescriptionColor: UIColor { get set }
    /// Default applied in `CardPartTableViewCell` and `CardPartTitleDescriptionView`
    var secondaryTitlePosition : CardPartSecondaryTitleDescPosition { get set }

}

extension CardPartsTheme {
    /// Update global theme
    public func apply() {
        CardParts.theme = self
    }
}

/// Default theme for Mint product
public class CardPartsMintTheme: CardPartsTheme {
    
    /// See `CardPartsTheme`
    public var cardsViewContentInsetTop: CGFloat = 0.0
    /// See `CardPartsTheme`
    public var cardsLineSpacing: CGFloat = 12
    
    /// See `CardPartsTheme`
    public var cardShadow: Bool = true
    /// See `CardPartsTheme`
    public var cardCellMargins: UIEdgeInsets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 12.0, right: 12.0)
    /// See `CardPartsTheme`
    public var cardPartMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
    
    // CardPartSeparatorView
    /// See `CardPartsTheme`
    public var separatorColor: UIColor = UIColor.color(221, green: 221, blue: 221)
    /// See `CardPartsTheme`
    public var horizontalSeparatorMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
    
    // CardPartTextView
    /// See `CardPartsTheme`
    public var smallTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(10))!
    /// See `CardPartsTheme`
    public var smallTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    /// See `CardPartsTheme`
    public var normalTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(14))!
    /// See `CardPartsTheme`
    public var normalTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    /// See `CardPartsTheme`
    public var titleTextFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))!
    /// See `CardPartsTheme`
    public var titleTextColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    /// See `CardPartsTheme`
    public var headerTextFont: UIFont = UIFont.turboGenericFontBlack(.header)
    /// See `CardPartsTheme`
    public var headerTextColor: UIColor = UIColor.turboCardPartTitleColor
    /// See `CardPartsTheme`
    public var detailTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    /// See `CardPartsTheme`
    public var detailTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    
    // CardPartTitleView
    /// See `CardPartsTheme`
    public var titleFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))!
    /// See `CardPartsTheme`
    public var titleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    /// See `CardPartsTheme`
    public var titleViewMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 10.0, right: 15.0)
    
    // CardPartButtonView
    /// See `CardPartsTheme`
    public var buttonTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    /// See `CardPartsTheme`
    public var buttonTitleColor: UIColor = UIColor(red: 69.0/255.0, green: 202.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    /// See `CardPartsTheme`
    public var buttonCornerRadius: CGFloat = CGFloat(0.0)
    
    // CardPartBarView
    /// See `CardPartsTheme`
    public var barBackgroundColor: UIColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    /// See `CardPartsTheme`
    public var barColor: UIColor = UIColor.turboHeaderBlueColor
    /// See `CardPartsTheme`
    public var todayLineColor: UIColor = UIColor.Gray8
    /// See `CardPartsTheme`
    public var barHeight: CGFloat = 13.5
    /// See `CardPartsTheme`
    public var roundedCorners: Bool = false
    /// See `CardPartsTheme`
    public var showTodayLine: Bool = true
    
    // CardPartTableView
    /// See `CardPartsTheme`
    public var tableViewMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0)
    
    // CardPartTableViewCell and CardPartTitleDescriptionView
    /// See `CardPartsTheme`
    public var leftTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    /// See `CardPartsTheme`
    public var leftDescriptionFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    /// See `CardPartsTheme`
    public var rightTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    /// See `CardPartsTheme`
    public var rightDescriptionFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    /// See `CardPartsTheme`
    public var leftTitleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    /// See `CardPartsTheme`
    public var leftDescriptionColor: UIColor = UIColor.color(169, green: 169, blue: 169)
    /// See `CardPartsTheme`
    public var rightTitleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    /// See `CardPartsTheme`
    public var rightDescriptionColor: UIColor = UIColor.color(169, green: 169, blue: 169)
    /// See `CardPartsTheme`
    public var secondaryTitlePosition : CardPartSecondaryTitleDescPosition = .right
    
    /// Unused
    public init() {
        
    }
}


/// Default theme for Turbo product
public class CardPartsTurboTheme: CardPartsTheme {

    /// See `CardPartsTheme`
    public var cardsViewContentInsetTop: CGFloat = 0.0
    /// See `CardPartsTheme`
    public var cardsLineSpacing: CGFloat = 12

    /// See `CardPartsTheme`
    public var cardShadow: Bool = false
    /// See `CardPartsTheme`
    public var cardCellMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    /// See `CardPartsTheme`
    public var cardPartMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 28.0, bottom: 5.0, right: 28.0)

    // CardPartSeparatorView
    /// See `CardPartsTheme`
    public var separatorColor: UIColor = UIColor.turboSeperatorColor
    /// See `CardPartsTheme`
    public var horizontalSeparatorMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)

    // CardPartTextView
    /// See `CardPartsTheme`
    public var smallTextFont: UIFont = UIFont.turboGenericFont(.x_Small)
    /// See `CardPartsTheme`
    public var smallTextColor: UIColor = UIColor.turboCardPartTextColor
    /// See `CardPartsTheme`
    public var normalTextFont: UIFont = UIFont.turboGenericFont(.normal)
    /// See `CardPartsTheme`
    public var normalTextColor: UIColor = UIColor.turboCardPartTextColor
    /// See `CardPartsTheme`
    public var titleTextFont: UIFont = UIFont.turboGenericMediumFont(.medium)
    /// See `CardPartsTheme`
    public var titleTextColor: UIColor = UIColor.turboCardPartTitleColor
    /// See `CardPartsTheme`
    public var headerTextFont: UIFont = UIFont.turboGenericFontBlack(.header)
    /// See `CardPartsTheme`
    public var headerTextColor: UIColor = UIColor.turboCardPartTitleColor
    /// See `CardPartsTheme`
    public var detailTextFont: UIFont = UIFont.turboGenericFont(.small)
    /// See `CardPartsTheme`
    public var detailTextColor: UIColor = UIColor.turboCardPartTextColor
    
    // CardPartTitleView
    /// See `CardPartsTheme`
    public var titleFont: UIFont = UIFont.turboGenericMediumFont(.medium)
    /// See `CardPartsTheme`
    public var titleColor: UIColor = UIColor.turboCardPartTitleColor
    /// See `CardPartsTheme`
    public var titleViewMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 28.0, bottom: 10.0, right: 28.0)

    // CardPartButtonView
    /// See `CardPartsTheme`
    public var buttonTitleFont: UIFont = UIFont.turboGenericFont(.large)
    /// See `CardPartsTheme`
    public var buttonTitleColor: UIColor = UIColor.turboBlueColor
    /// See `CardPartsTheme`
    public var buttonCornerRadius: CGFloat = CGFloat(0.0)

    // CardPartBarView
    /// See `CardPartsTheme`
    public var barBackgroundColor: UIColor = UIColor.turboSeperatorGray
    /// See `CardPartsTheme`
    public var barColor: UIColor = UIColor.turboHeaderBlueColor
    /// See `CardPartsTheme`
    public var todayLineColor: UIColor = UIColor.Gray8
    /// See `CardPartsTheme`
    public var barHeight: CGFloat = 20.0
    /// See `CardPartsTheme`
    public var roundedCorners: Bool = true
    /// See `CardPartsTheme`
    public var showTodayLine: Bool = false

    // CardPartTableView
    /// See `CardPartsTheme`
    public var tableViewMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 28.0, bottom: 0.0, right: 28.0)

    // CardPartTableViewCell and CardPartTitleDescriptionView
    /// See `CardPartsTheme`
    public var leftTitleFont: UIFont = UIFont.turboGenericFont(.large)
    /// See `CardPartsTheme`
    public var leftDescriptionFont: UIFont = UIFont.turboGenericFont(.small)
    /// See `CardPartsTheme`
    public var rightTitleFont: UIFont = UIFont.turboGenericFont(.large)
    /// See `CardPartsTheme`
    public var rightDescriptionFont: UIFont = UIFont.turboGenericFont(.small)
    /// See `CardPartsTheme`
    public var leftTitleColor: UIColor = UIColor.turboCardPartTitleColor
    /// See `CardPartsTheme`
    public var leftDescriptionColor: UIColor = UIColor.turboGenericGreyTextColor
    /// See `CardPartsTheme`
    public var rightTitleColor: UIColor = UIColor.turboCardPartTitleColor
    /// See `CardPartsTheme`
    public var rightDescriptionColor: UIColor = UIColor.turboGenericGreyTextColor
    /// See `CardPartsTheme`
    public var secondaryTitlePosition : CardPartSecondaryTitleDescPosition = .center(amount: 0.0)

    /// Unused
    public init() {
        
    }

}

