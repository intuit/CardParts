//
//  CardPartTriangleView.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 9/19/19.
//

import Foundation

class CardPartTriangleView: UIView,CardPartView {
        
    var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    var fillColor: UIColor = .Label
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let layerHeight = layer.frame.height
        
        let layerWidth = layer.frame.width
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth / 2, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        fillColor.setFill()
        bezierPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}
