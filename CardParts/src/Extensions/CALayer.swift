//
//  CALayer.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 10/28/19.
//

import UIKit

extension CALayer {
    
    func addRectangleLayer(frame: CGRect, color: CGColor, animated: Bool, oldFrame: CGRect?, cornerRadius: CGFloat = 0.0) {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color
        layer.cornerRadius = cornerRadius
        if #available(iOS 11.0, *) {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = frame
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            shapeLayer.path = path.cgPath
            layer.mask = shapeLayer
        }
       
        self.addSublayer(layer)
        
        if animated, let oldFrame = oldFrame {
            layer.animate(fromValue: CGPoint(x: oldFrame.midX, y: oldFrame.midY), toValue: layer.position, keyPath: "position")
            layer.animate(fromValue: CGRect(x: 0, y: 0, width: oldFrame.width, height: oldFrame.height), toValue: layer.bounds, keyPath: "bounds")
        }
    }
    
    func addLineLayer(lineSegment: LineSegment, color: CGColor, width: CGFloat, isDashed: Bool, animated: Bool, oldSegment: LineSegment?) {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(lineSegment: lineSegment).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = width
        if isDashed {
            layer.lineDashPattern = [4, 4]
        }
        self.addSublayer(layer)
        
        if animated, let segment = oldSegment {
            layer.animate(
                fromValue: UIBezierPath(lineSegment: segment).cgPath,
                toValue: layer.path!,
                keyPath: "path")
        }
    }
    
    func animate(fromValue: Any, toValue: Any, keyPath: String) {
        let anim = CABasicAnimation(keyPath: keyPath)
        anim.fromValue = fromValue
        anim.toValue = toValue
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.add(anim, forKey: keyPath)
    }
}
