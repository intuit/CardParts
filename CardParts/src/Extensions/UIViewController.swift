//
//  UIViewController.swift
//  CardParts
//
//  Created by Ryan Cole on 2/17/20.
//

import Foundation
import UIKit

extension UIViewController {
    func height(width: CGFloat) -> CGFloat {
        view.layoutIfNeeded()
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        let size = view.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        return size.height
    }
    
    func add(_ child: UIViewController) {
        // First, add the view of the child to the view of the parent
        addChild(child)
        
        // Then, add the child to the parent
        view.addSubview(child.view)
        
        // Finally, notify the child that it was moved to a parent
        child.didMove(toParent: self)
    }
    
    func removeFromParentVC() {
        // Check that view controller has a parent before removing it
        guard let _ = parent else { return }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
