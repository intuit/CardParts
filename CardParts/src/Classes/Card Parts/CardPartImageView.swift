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

public class CardPartImageView : UIImageView, CardPartView {
	
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
	public var imageName: String? {
		didSet {
			guard let name = imageName else { return }
			self.image = UIImage(named: name)
		}
	}
}

extension Reactive where Base: CardPartImageView {
	
	public var imageName: Binder<String?>{
		return Binder(self.base) { (imageView, imageName) -> () in
			imageView.imageName = imageName
		}
	}

	public var contentMode: Binder<UIView.ContentMode>{
		return Binder(self.base) { (imageView, contentMode) -> () in
			imageView.contentMode = contentMode
		}
	}
}
