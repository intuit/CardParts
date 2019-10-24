//
//  AssetManager.swift
//  CardParts
//
//  Created by Eude K Lesperance on 10/18/19.
//

import UIKit

class AssetManager {
    static let shared = AssetManager()
    
    private let cache: NSCache = NSCache<NSString, UIImage>()
    
    init() {
        // render and cache the default size images
        Icon.allCases.forEach { icon in _ = image(for: icon)}
    }
    
    func image(for icon: Icon, in rect: CGRect = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)) -> UIImage {
        let key = "\(icon)_\(rect.width)x\(rect.height)" as NSString
        if let cachedImage = cache.object(forKey: key) {
            return cachedImage
        }
        
        let image = render(icon, in: rect)
        cache.setObject(image, forKey: key)
        return image
    }
    
    private func render(_ icon: Icon, in rect: CGRect) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
        
        let image = renderer.image { ctx in
            ctx.cgContext.scaleBy(x: rect.width / 24.0, y: rect.height / 24.0)
            let path = icon.bezierPath()
            if icon == .confetti {
                UIColor.white.setStroke()
                path.stroke()
            } else {
                UIColor.white.setFill()
                path.fill()
            }
        }
        
        return image.withRenderingMode(.alwaysTemplate)
    }
}

extension AssetManager {
    enum Icon: CaseIterable {
        case arrowDown, star, diamond, triangle, pencil, confetti
        
        func bezierPath() -> UIBezierPath {
            switch self {
            case .arrowDown: return arrowDown()
            case .star: return star()
            case .diamond: return diamond()
            case .triangle: return triangle()
            case .pencil: return pencil()
            case .confetti: return confetti()
            }
        }
        
        private func arrowDown() -> UIBezierPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 7.41, y: 8.59))
            path.addLine(to: CGPoint(x: 12, y: 13.17))
            path.addLine(to: CGPoint(x: 16.59, y: 8.59))
            path.addLine(to: CGPoint(x: 18, y: 10))
            path.addLine(to: CGPoint(x: 12, y: 16))
            path.addLine(to: CGPoint(x: 6, y: 10))
            path.addLine(to: CGPoint(x: 7.41, y: 8.59))
            path.close()
            return path
        }
        
        private func star() -> UIBezierPath {
            let size = CGSize(width: 24.0, height: 24.0)
            let sides = 5
            let radius: CGFloat = min(size.width, size.height) / 2.0
            let origin = CGPoint(x: size.width / 2.0 , y:  size.height / 2.0)
            let pointiness: CGFloat = 2.0
            let startAngle = CGFloat(-1 * (360 / sides / 4))
            let adjustment = startAngle + CGFloat(360 / sides / 2)

            let points = polygonPoints(sides: sides, radius: radius / pointiness, origin: origin, adjustment: startAngle)
            let points2 = polygonPoints(sides: sides, radius: radius, origin: origin, adjustment: adjustment)
            
            let path = UIBezierPath()
            path.move(to: points[0])
            points.enumerated().forEach { i, point in
                path.addLine(to: points2[i])
                path.addLine(to: point)
            }
            path.close()
            return path
        }
        
        private func confetti() -> UIBezierPath {
            let linewidth: CGFloat = 4.0
            let size = CGSize(width: 24.0, height: 24.0)
            let radius: CGFloat = (min(size.width, size.height) - linewidth) / 2.0
            let origin = CGPoint(x: size.width / 2.0 , y:  size.height / 2.0)
            let path = UIBezierPath(arcCenter: origin, radius: radius, startAngle: radian(from: 270), endAngle: radian(from: 180), clockwise: false)
            path.lineWidth = linewidth
            return path
        }
        
        private func triangle() -> UIBezierPath {
            let size = CGSize(width: 24.0, height: 24.0)
            let sides = 3
            let radius: CGFloat = min(size.width, size.height) / 2.0
            let origin = CGPoint(x: size.width / 2.0 , y:  size.height / 2.0)
            let startAngle = CGFloat(-1 * (360 / sides / 4))
            let adjustment = startAngle + CGFloat(360 / sides / 2)
            
            let points = polygonPoints(sides: sides, radius: radius, origin: origin, adjustment: adjustment)
            
            let path = UIBezierPath()
            path.move(to: points[0])
            points.enumerated().forEach { _, point in
                print(point)
                path.addLine(to: point)
            }
            return path
        }
        
        private func diamond() -> UIBezierPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 11.96, y: 3.15))
            path.addLine(to: CGPoint(x: 11.85, y: 3))
            path.addLine(to: CGPoint(x: 5.24, y: 12.19))
            path.addLine(to: CGPoint(x: 5.17, y: 12.29))
            path.addLine(to: CGPoint(x: 12.24, y: 21.07))
            path.addLine(to: CGPoint(x: 12.27, y: 21.11))
            path.addLine(to: CGPoint(x: 18.88, y: 11.81))
            path.addLine(to: CGPoint(x: 18.95, y: 11.71))
            path.addLine(to: CGPoint(x: 11.96, y: 3.15))
            path.close()
            return path
        }
        
        private func pencil() -> UIBezierPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 3, y: 17.25))
            path.addLine(to: CGPoint(x: 3, y: 21))
            path.addLine(to: CGPoint(x: 6.75, y: 21))
            path.addLine(to: CGPoint(x: 17.81, y: 9.94))
            path.addLine(to: CGPoint(x: 14.06, y: 6.19))
            path.addLine(to: CGPoint(x: 3, y: 17.25))
            path.close()
            path.move(to: CGPoint(x: 20.71, y: 7.04))
            path.addCurve(to: CGPoint(x: 20.71, y: 5.63),
                          controlPoint1: CGPoint(x: 21.1, y: 6.65),
                          controlPoint2: CGPoint(x: 21.1, y: 6.02))
            path.addLine(to: CGPoint(x: 18.37, y: 3.29))
            path.addCurve(to: CGPoint(x: 16.96, y: 3.29),
                          controlPoint1: CGPoint(x: 17.98, y: 2.9),
                          controlPoint2: CGPoint(x: 17.35, y: 2.9))
            path.addLine(to: CGPoint(x: 15.13, y: 5.12))
            path.addLine(to: CGPoint(x: 18.88, y: 8.87))
            path.addLine(to: CGPoint(x: 20.71, y: 7.04))
            path.close()
            return path
        }
        
        private func radian(from degree: CGFloat) -> CGFloat {
            return CGFloat(Double.pi) * degree / 180.0
        }

        private func polygonPoints(sides: Int, radius: CGFloat, origin: CGPoint, adjustment: CGFloat = 0.0) -> [CGPoint] {
            let angle = radian(from: 360 / CGFloat(sides))
            let points: [CGPoint] = (0...sides).reversed()
                .map { side in
                    return CGPoint (
                        x: origin.x - radius * cos(angle * CGFloat(side) + radian(from: adjustment)),
                        y: origin.y - radius * sin(angle * CGFloat(side) + radian(from: adjustment))
                    )
            }
            return points
        }
    }
}
