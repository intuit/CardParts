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
    
    class func turboGenericFont(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.regular)
    }
    
    class func turboGenericFontBlack(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.black)
    }

    class func turboGenericFontBold(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.bold)
    }
    
    class func turboGenericMediumFont(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.medium)
    }
    
    class func turboGenericLightFont(_ fontSize: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(fontSize.rawValue), weight: UIFont.Weight.light)
    }
    
    class func turboGenericFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    class func turboGenericMediumFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    class func turboGenericLightFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }

    static var titleTextMedium : UIFont {get{return UIFont.systemFont(ofSize: CGFloat(FontSize.x_Large.rawValue), weight: UIFont.Weight.medium)}}
}
