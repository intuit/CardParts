//
//  CardPartMultiSliderExtensions.swift
//  CardPartMultiSlider
//
//  Created by Brian Carreon on 20.05.2018.
//

import UIKit

extension CGFloat {
    func truncated(_ step: CGFloat) -> CGFloat {
        return step.isNormal ? self - remainder(dividingBy: step) : self
    }

    func rounded(_ step: CGFloat) -> CGFloat {
        guard step.isNormal && isNormal else { return self }
        return (self / step).rounded() * step
    }
}

extension CGPoint {
    func coordinate(in axis: NSLayoutConstraint.Axis) -> CGFloat {
        switch axis {
        case .vertical:
            return y
        default:
            return x
        }
    }
}

extension CGRect {
    func size(in axis: NSLayoutConstraint.Axis) -> CGFloat {
        switch axis {
        case .vertical:
            return height
        default:
            return width
        }
    }

    func bottom(in axis: NSLayoutConstraint.Axis) -> CGFloat {
        switch axis {
        case .vertical:
            return maxY
        default:
            return minX
        }
    }

    func top(in axis: NSLayoutConstraint.Axis) -> CGFloat {
        switch axis {
        case .vertical:
            return minY
        default:
            return maxX
        }
    }
}

extension UIView {
    var diagonalSize: CGFloat { return hypot(frame.width, frame.height) }

    func removeFirstConstraint(where: (_: NSLayoutConstraint) -> Bool) {
        if let constrainIndex = constraints.firstIndex(where: `where`) {
            removeConstraint(constraints[constrainIndex])
        }
    }

    func addShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 0.5
    }
}

extension Array where Element: UIView {
    mutating func removeViewsStartingAt(_ index: Int) {
        guard index >= 0 && index < count else { return }
        self[index ..< count].forEach { $0.removeFromSuperview() }
        removeLast(count - index)
    }
}

extension UIImageView {
    func blur(_ on: Bool) {
        if on {
            guard nil == viewWithTag(UIImageView.blurViewTag) else { return }
            let blurImage = image?.withRenderingMode(.alwaysTemplate)
            let blurView = UIImageView(image: blurImage)
            blurView.tag = UIImageView.blurViewTag
            blurView.tintColor = .white
            blurView.alpha = 0.5
            addConstrainedSubview(blurView, constrain: .top, .bottom, .left, .right)
            layer.shadowOpacity /= 2
        } else {
            guard let blurView = viewWithTag(UIImageView.blurViewTag) else { return }
            blurView.removeFromSuperview()
            layer.shadowOpacity *= 2
        }
    }

    static var blurViewTag: Int { return 898_989 } // swiftlint:disable:this numbers_smell
}

extension NSLayoutConstraint.Attribute {
    var opposite: NSLayoutConstraint.Attribute {
        switch self {
        case .left: return .right
        case .right: return .left
        case .top: return .bottom
        case .bottom: return .top
        case .leading: return .trailing
        case .trailing: return .leading
        case .leftMargin: return .rightMargin
        case .rightMargin: return .leftMargin
        case .topMargin: return .bottomMargin
        case .bottomMargin: return .topMargin
        case .leadingMargin: return .trailingMargin
        case .trailingMargin: return .leadingMargin
        default: return self
        }
    }

    var inwardSign: CGFloat {
        switch self {
        case .top, .topMargin: return 1
        case .bottom, .bottomMargin: return -1
        case .left, .leading, .leftMargin, .leadingMargin: return 1
        case .right, .trailing, .rightMargin, .trailingMargin: return -1
        default: return 1
        }
    }

    var perpendicularCenter: NSLayoutConstraint.Attribute {
        switch self {
        case .left, .leading, .leftMargin, .leadingMargin, .right, .trailing, .rightMargin, .trailingMargin, .centerX:
            return .centerY
        default:
            return .centerX
        }
    }

    static func center(in axis: NSLayoutConstraint.Axis) -> NSLayoutConstraint.Attribute {
        switch axis {
        case .vertical:
            return .centerY
        default:
            return .centerX
        }
    }

    static func top(in axis: NSLayoutConstraint.Axis) -> NSLayoutConstraint.Attribute {
        switch axis {
        case .vertical:
            return .top
        default:
            return .trailing
        }
    }

    static func bottom(in axis: NSLayoutConstraint.Axis) -> NSLayoutConstraint.Attribute {
        switch axis {
        case .vertical:
            return .bottom
        default:
            return .leading
        }
    }
}

extension CACornerMask {
    static func direction(_ attribute: NSLayoutConstraint.Attribute) -> CACornerMask {
        switch attribute {
        case .bottom:
            return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .top:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .leading, .left:
            return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .trailing, .right:
            return [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        default:
            return []
        }
    }
}

extension UIImage {
    static func circle(diameter: CGFloat = 29, width: CGFloat = 0.5, color: UIColor? = UIColor.lightGray.withAlphaComponent(0.5), fill: UIColor? = .white) -> UIImage? {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = fill?.cgColor
        circleLayer.strokeColor = color?.cgColor
        circleLayer.lineWidth = width
        let margin = width * 2
        let circle = UIBezierPath(ovalIn: CGRect(x: margin, y: margin, width: diameter, height: diameter))
        circleLayer.bounds = CGRect(x: 0, y: 0, width: diameter + margin * 2, height: diameter + margin * 2)
        circleLayer.path = circle.cgPath
        UIGraphicsBeginImageContextWithOptions(circleLayer.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        circleLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension NSObject {
    func addObserverForAllProperties(
        observer: NSObject,
        options: NSKeyValueObservingOptions = [],
        context: UnsafeMutableRawPointer? = nil
    ) {
        performForAllKeyPaths { keyPath in
            addObserver(observer, forKeyPath: keyPath, options: options, context: context)
        }
    }

    func removeObserverForAllProperties(
        observer: NSObject,
        context: UnsafeMutableRawPointer? = nil
    ) {
        performForAllKeyPaths { keyPath in
            removeObserver(observer, forKeyPath: keyPath, context: context)
        }
    }

    func performForAllKeyPaths(_ action: (String) -> Void) {
        var count: UInt32 = 0
        guard let properties = class_copyPropertyList(object_getClass(self), &count) else { return }
        defer { free(properties) }
        for i in 0 ..< Int(count) {
            let keyPath = String(cString: property_getName(properties[i]))
            action(keyPath)
        }
    }
}
