//
//  CardPartImageView.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/22/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// CardPartImageView displays a single image. CardPartImageView exposes the following reactive properties that can be bound to view model properties:
///```
///var image: UIImage?
///var imageName: String?
///var alpha: CGFloat
///var backgroundColor: UIColor?
///var isHidden: Bool
///var isUserInteractionEnabled: Bool
///var tintColor: UIColor?
///```
public class CardPartImageView : UIImageView, CardPartView {
	
    /// CardParts theme margins by default
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
    /// name of image
	public var imageName: String? {
		didSet {
			guard let name = imageName else { return }
			self.image = UIImage(named: name)
		}
	}
}

extension Reactive where Base: CardPartImageView {
	
    /// Updates imageView's imageName
	public var imageName: Binder<String?>{
		return Binder(self.base) { (imageView, imageName) -> () in
			imageView.imageName = imageName
		}
	}

    /// Updates imageView's contentMode
	public var contentMode: Binder<UIView.ContentMode>{
		return Binder(self.base) { (imageView, contentMode) -> () in
			imageView.contentMode = contentMode
		}
	}
}
