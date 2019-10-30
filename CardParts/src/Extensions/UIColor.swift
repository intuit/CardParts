//
//  UIColor.swift
//  Turbo
//
//  Created by Roossin, Chase on 11/21/17.
//  Copyright © 2017 Intuit, Inc. All rights reserved.
//

extension UIColor {
    class func color(_ red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
    
    static func colorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    static var cardPartGrayTextColor : UIColor {get{return UIColor.dynamicColor(light: .Gray2, dark: .Gray3)}}
    static var cardPartTitleColor : UIColor {get{return UIColor.dynamicColor(light: .Black, dark: .white)}}
    static var cardPartTextColor : UIColor {get{return UIColor.dynamicColor(light: .Gray0, dark: .Gray7)}}
    static var cardPartSeparatorColor : UIColor {get{return UIColor.dynamicColor(light: .Gray4, dark: .Gray2)}}
    static var cardPartBlueColor : UIColor {get{return .SystemBlue}}
    static var cardPartHeaderBlueColor: UIColor { get { return .SystemBlue}}
    static var cardPartGreenColor : UIColor {get{return UIColor.dynamicColor(light: UIColor.colorFromHex(0x0AC775), dark: UIColor.colorFromHex(0x3DFAA8))}}
    
    static var Black : UIColor {get{return UIColor.colorFromHex(0x000000)}}
    static var Gray0 : UIColor {get{return UIColor.colorFromHex(0x333333)}}
    static var Gray1 : UIColor {get{return UIColor.colorFromHex(0x666666)}}
    static var Gray2 : UIColor {get{return UIColor.colorFromHex(0x999999)}}
    static var Gray3 : UIColor {get{return UIColor.colorFromHex(0xCCCCCC)}}
    static var Gray4 : UIColor {get{return UIColor.colorFromHex(0xDDDDDD)}}
    static var Gray5 : UIColor {get{return UIColor.colorFromHex(0xF0F0F0)}}
    static var Gray6 : UIColor {get{return UIColor.colorFromHex(0xF5F5F5)}}
    static var Gray7 : UIColor {get{return UIColor.colorFromHex(0xE7E7E7)}}
    static var Gray8 : UIColor {get{return UIColor.colorFromHex(0xB2B2B2)}}

    //Confetti Colors
    public static var flushOrange : UIColor {get{return UIColor.dynamicColor(light: UIColor.colorFromHex(0xFF8000), dark: UIColor.colorFromHex(0xFF9A1A))}}
    public static var eggBlue : UIColor {get{return UIColor.dynamicColor(light: UIColor.colorFromHex(0x07C4D9), dark: UIColor.colorFromHex(0x21DEF3))}}
    public static var blushPink: UIColor {get{return UIColor.dynamicColor(light: UIColor.colorFromHex(0xFF88EC), dark: UIColor.colorFromHex(0xFFA2FF))}}
    public static var cerulean: UIColor {get{return UIColor.dynamicColor(light: UIColor.colorFromHex(0x0097E6), dark: UIColor.colorFromHex(0x1AB1FF))}}
    public static var limeGreen: UIColor {get{return UIColor.dynamicColor(light: UIColor.colorFromHex(0x53B700), dark: UIColor.colorFromHex(0x6DD11A))}}
    public static var yellowSea: UIColor {get{return UIColor.dynamicColor(light: UIColor.colorFromHex(0xFFAD00), dark: UIColor.colorFromHex(0xFFC71A))}}
    public static var superNova: UIColor {get{return UIColor.dynamicColor(light: UIColor.colorFromHex(0xFFCA00), dark: UIColor.colorFromHex(0xFFE41A))}}
}

// MARK: - Pre-iOS 13 Compatibility

extension UIColor {
    // Adaptable Colors
    static var SystemBlue : UIColor {get {if #available(iOS 13.0, *){return .systemBlue} else {return UIColor.color(0, green: 122, blue: 255)}}}
    static var SystemGreen : UIColor {get {if #available(iOS 13.0, *){return .systemGreen} else {return UIColor.color(52, green: 199, blue: 89)}}}
    static var SystemIndigo : UIColor {get {if #available(iOS 13.0, *){return .systemIndigo} else {return UIColor.color(88, green: 86, blue: 214)}}}
    static var SystemOrange : UIColor {get {if #available(iOS 13.0, *){return .systemOrange} else {return UIColor.color(255, green: 149, blue: 0)}}}
    static var SystemPink : UIColor {get {if #available(iOS 13.0, *){return .systemPink} else {return UIColor.color(255, green: 45, blue: 85)}}}
    static var SystemPurple : UIColor {get {if #available(iOS 13.0, *){return .systemPurple} else {return UIColor.color(175, green: 82, blue: 222)}}}
    static var SystemRed : UIColor {get {if #available(iOS 13.0, *){return .systemRed} else {return UIColor.color(255, green: 59, blue: 48)}}}
    static var SystemTeal : UIColor {get {if #available(iOS 13.0, *){return .systemTeal} else {return UIColor.color(90, green: 200, blue: 250)}}}
    static var SystemYellow : UIColor {get {if #available(iOS 13.0, *){return .systemYellow} else {return UIColor.color(255, green: 204, blue: 0)}}}
    
    // Adaptable Gray Colors
    static var SystemGray : UIColor {get {if #available(iOS 13.0, *){return .systemGray} else {return UIColor.color(142, green: 142, blue: 147)}}}
    static var SystemGray2 : UIColor {get {if #available(iOS 13.0, *){return .systemGray2} else {return UIColor.color(174, green: 174, blue: 178)}}}
    static var SystemGray3 : UIColor {get {if #available(iOS 13.0, *){return .systemGray3} else {return UIColor.color(199, green: 199, blue: 204)}}}
    static var SystemGray4 : UIColor {get {if #available(iOS 13.0, *){return .systemGray4} else {return UIColor.color(209, green: 209, blue: 214)}}}
    static var SystemGray5 : UIColor {get {if #available(iOS 13.0, *){return .systemGray5} else {return UIColor.color(229, green: 229, blue: 234)}}}
    static var SystemGray6 : UIColor {get {if #available(iOS 13.0, *){return .systemGray6} else {return UIColor.color(242, green: 242, blue: 247)}}}
    
    // Label Colors
    static var Label : UIColor {get {if #available(iOS 13.0, *){return .label} else {return UIColor.color(242, green: 242, blue: 247)}}}
    static var SecondaryLabel : UIColor {get {if #available(iOS 13.0, *){return .secondaryLabel} else {return UIColor.color(242, green: 242, blue: 247)}}}
    static var TertiaryLabel : UIColor {get {if #available(iOS 13.0, *){return .tertiaryLabel} else {return UIColor.color(242, green: 242, blue: 247)}}}
    static var QuaternaryLabel : UIColor {get {if #available(iOS 13.0, *){return .quaternaryLabel} else {return UIColor.color(242, green: 242, blue: 247)}}}
    
    // Fill Colors
    static var SystemFill : UIColor {get {if #available(iOS 13.0, *){return .systemFill} else {return UIColor.color(120, green: 120, blue: 128, alpha: 0.2)}}}
    static var SecondarySystemFill : UIColor {get {if #available(iOS 13.0, *){return .secondarySystemFill} else {return UIColor.color(120, green: 120, blue: 128, alpha: 0.16)}}}
    static var TertiarySystemFill : UIColor {get {if #available(iOS 13.0, *){return .tertiarySystemFill} else {return UIColor.color(120, green: 120, blue: 128, alpha: 0.12)}}}
    static var QuaternarySystemFill : UIColor {get {if #available(iOS 13.0, *){return .quaternarySystemFill} else {return UIColor.color(120, green: 120, blue: 128, alpha: 0.08)}}}
    
    // Text Colors
    static var PlaceholderText : UIColor {get {if #available(iOS 13.0, *){return .placeholderText} else {return UIColor.color(242, green: 242, blue: 247)}}}
    
    // Standard Content Background Colors
    static var SystemBackground  : UIColor {get {if #available(iOS 13.0, *){return .systemBackground} else {return UIColor.color(255, green: 255, blue: 255)}}}
    static var SecondarySystemBackground  : UIColor {get {if #available(iOS 13.0, *){return .secondarySystemBackground} else {return UIColor.color(242, green: 242, blue: 247)}}}
    static var TertiarySystemBackground : UIColor {get {if #available(iOS 13.0, *){return .tertiarySystemBackground} else {return UIColor.color(255, green: 255, blue: 255)}}}
    
    // Grouped Content Background Colors
    static var SystemGroupedBackground  : UIColor {get {if #available(iOS 13.0, *){return .systemGroupedBackground} else {return UIColor.color(242, green: 242, blue: 247)}}}
    static var SecondarySystemGroupedBackground  : UIColor {get {if #available(iOS 13.0, *){return .secondarySystemGroupedBackground} else {return UIColor.color(255, green: 255, blue: 255)}}}
    static var TertiarySystemGroupedBackground : UIColor {get {if #available(iOS 13.0, *){return .tertiarySystemGroupedBackground} else {return UIColor.color(242, green: 242, blue: 247)}}}
    
    // Separator Colors
    static var Separator : UIColor {get {if #available(iOS 13.0, *){return .separator} else {return UIColor.color(242, green: 242, blue: 247)}}}
    static var OpaqueSeparator : UIColor {get {if #available(iOS 13.0, *){return .opaqueSeparator} else {return UIColor.color(242, green: 242, blue: 247)}}}
    
    // Link Color
    static var Link : UIColor {get {if #available(iOS 13.0, *){return .link} else {return UIColor.color(242, green: 242, blue: 247)}}}
    
    // Nonadaptable Colors
    static var DarkText : UIColor {get {if #available(iOS 13.0, *){return .link} else {return UIColor.color(242, green: 242, blue: 247)}}}
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: { traits in
                if traits.userInterfaceStyle == .dark {
                    return dark
                }
                return light
            })
        }
        return light
    }
    
    // CGColor for traitCollection
    func cgColor(with traitCollection: UITraitCollection) -> CGColor {
        if #available(iOS 13.0, *) {
            return self.resolvedColor(with: traitCollection).cgColor
        }
        return self.cgColor
    }
}
