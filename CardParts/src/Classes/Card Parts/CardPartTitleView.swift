//
//  CardPartTitleView.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/22/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum CardPartTitleType {
	case titleOnly
	case titleWithMenu
	case titleWithActionableButton
}

public class CardPartTitleView : UIView, CardPartView {
	
	public var title: String? {
		didSet {
			label.text = title
		}
	}
	public var titleFont: UIFont = CardParts.theme.titleFont {
		didSet {
			label.font = titleFont
		}
	}
	public var titleColor: UIColor = CardParts.theme.titleColor {
		didSet {
			label.textColor = titleColor
		}
	}
	public var menuTitle: String?
	public var menuOptions: [String]?
    public var menuButtonImage: UIImage? = nil {
        didSet {
            if type == .titleWithMenu || type == .titleWithActionableButton {
                if let image = menuButtonImage {
                    button?.setImage(image, for: .normal)
                }
            }
        }
    }
	public var menuButtonImageName: String = "arrowdown" {
		didSet {
			if type == .titleWithMenu || type == .titleWithActionableButton {
                menuButtonImage = UIImage(named: menuButtonImageName, in: Bundle(for: CardPartTitleView.self), compatibleWith: nil)
			}
		}
	}
	public var menuOptionObserver: ((String, Int) -> Void)?
	public var menuActionableCallback: (()->())?
	
	public var margins: UIEdgeInsets = CardParts.theme.titleViewMargins
	
	private let type: CardPartTitleType
	public var label: UILabel
	public var button: UIButton?
	
    public init(type: CardPartTitleType) {
		
		self.type = type
		
		label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
        super.init(frame: CGRect.zero)
		
		label.font = titleFont
		label.textColor = titleColor
		addSubview(label)

		if type == .titleWithMenu {
			button = UIButton()
			if let button = button {
				button.translatesAutoresizingMaskIntoConstraints = false
                if let image = menuButtonImage {
                    button.setImage(image, for: .normal)
                } else {
                    button.setImage(UIImage(named: menuButtonImageName, in: Bundle(for: CardPartTitleView.self), compatibleWith: nil), for: .normal)
                }
				button.addTarget(self, action: #selector(menuButtonTapped), for: UIControl.Event.touchUpInside)
				addSubview(button)
			}
		} else if type == .titleWithActionableButton {
			button = UIButton()
			if let button = button {
				button.translatesAutoresizingMaskIntoConstraints = false
                if let image = menuButtonImage {
                    button.setImage(image, for: .normal)
                } else {
                    button.setImage(UIImage(named: menuButtonImageName, in: Bundle(for: CardPartTitleView.self), compatibleWith: nil), for: .normal)
                }
				button.addTarget(self, action: #selector(actionableMenuTapped), for: UIControl.Event.touchUpInside)
				addSubview(button)
			}
		}
		
		setNeedsUpdateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override public func updateConstraints() {
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label" : label]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label" : label]))		
		if let button = button {
			addConstraints([NSLayoutConstraint (item: button,
			                                    attribute: NSLayoutConstraint.Attribute.width,
			                                    relatedBy: NSLayoutConstraint.Relation.equal,
			                                    toItem: nil,
			                                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
			                                    multiplier: 1,
			                                    constant: 40)])
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[button]|", options: [], metrics: nil, views: ["button" : button]))
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[button]|", options: [], metrics: nil, views: ["button" : button]))
		}
		
		super.updateConstraints()
	}
	
	@objc func menuButtonTapped() {
		
		guard let menuTitle = menuTitle, let menuOptions = menuOptions else { return }
		
		let alert = UIAlertController(title: menuTitle, message: nil, preferredStyle: .alert)
		
		var index = 0
		for menuItem in menuOptions {
			let menuIndex = index
			let action = UIAlertAction(title: menuItem, style: .default, handler: { [weak self] (action) in
				if let observer = self?.menuOptionObserver {
					observer(menuItem, menuIndex)
				}
			})
			alert.addAction(action)
			index += 1
		}
	
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{ (action) in
			alert.dismiss(animated: true, completion: nil)
		})
		alert.addAction(cancelAction)

		UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
	}
	
	@objc func actionableMenuTapped() {
		
		guard let action = menuActionableCallback else { return }
		
		action()
	}

}

extension Reactive where Base: CardPartTitleView {

	public var title: Binder<String?>{
		return Binder<String?>(self.base) { (titleView, title) -> () in
			titleView.title = title
		}
	}
	
	public var titleFont: Binder<UIFont>{
		return Binder(self.base) { (titleView, titleFont) -> () in
			titleView.titleFont = titleFont
		}
	}
	
	public var titleColor: Binder<UIColor>{
		return Binder(self.base) { (titleView, titleColor) -> () in
			titleView.titleColor = titleColor
		}
	}
	
	public var menuTitle: Binder<String?>{
		return Binder(self.base) { (titleView, menuTitle) -> () in
			titleView.menuTitle = menuTitle
		}
	}
	
	public var menuOptions: Binder<[String]?>{
		return Binder(self.base) { (titleView, menuOptions) -> () in
			titleView.menuOptions = menuOptions
		}
	}
	
	public var menuButtonImageName: Binder<String>{
		return Binder(self.base) { (titleView, menuButtonImageName) -> () in
			titleView.menuButtonImageName = menuButtonImageName
		}
	}
    
    public var menuButtonImage: Binder<UIImage?>{
        return Binder(self.base) { (titleView, menuButtonImage) -> () in
            titleView.menuButtonImage = menuButtonImage
        }
    }
}
