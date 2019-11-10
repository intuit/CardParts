//
//  UIBezierPath.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 10/28/19.
//

import Foundation
import UIKit

extension UIBezierPath {
    convenience init(lineSegment: LineSegment) {
        self.init()
        self.move(to: lineSegment.startPoint)
        self.addLine(to: lineSegment.endPoint)
    }
}
