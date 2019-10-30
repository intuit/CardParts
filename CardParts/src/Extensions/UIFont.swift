//
//  UIFont.swift
//  Turbo
//
//  Created by Roossin, Chase on 11/21/17.
//  Copyright © 2017 Intuit, Inc. All rights reserved.
//

enum FontSize: Int {
    case ultrabig = 48, header = 36, xx_Large = 28, x_Large = 24, large = 17, medium = 16, normal = 14, small = 12, x_Small = 10
}

extension UIFont {
    
    class func cardPartsFont(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.regular)
    }
    
    class func cardPartsFontBlack(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.black)
    }

    class func cardPartsFontBold(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.bold)
    }
    
    class func cardPartsMediumFont(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.medium)
    }
    
    class func cardPartsLightFont(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.light)
    }
    
    class func cardPartsFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    class func cardPartsMediumFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    class func cardPartsLightFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }

    static var titleTextMedium : UIFont {get{return UIFont.systemFont(ofSize: CGFloat(FontSize.x_Large.rawValue), weight: UIFont.Weight.medium)}}
}
