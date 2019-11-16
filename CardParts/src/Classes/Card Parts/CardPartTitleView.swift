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

/// Card Part title configuration
public enum CardPartTitleType {
    /// only title
    case titleOnly
    /// title and menu
    case titleWithMenu
    /// title and action button
	case titleWithActionableButton
}

///CardPartTitleView displays a view with a title, and an optional options menu. The initializer requires a type parameter which can be set to either titleOnly or titleWithMenu. If the type is set to titleWithMenu the card part will display a menu icon, that when tapped will display a menu containing the options specified in the menuOptions array. The menuOptionObserver property can be set to a block that will be called when the user selects an item from the menu.
///
///As an example for a title with menu buttons:
///````
///let titlePart = CardPartTitleView(type: .titleWithMenu)
///titlePart.menuTitle = "Hide this offer"
///titlePart.menuOptions = ["Hide"]
///titlePart.menuOptionObserver  = {[weak self] (title, index) in
///    // Logic to determine which menu option was clicked
///    // and how to respond
///    if index == 0 {
///        self?.hideOfferClicked()
///    }
///}
///```
///`CardPartButtonView` exposes the following reactive properties that can be bound to view model properties:
///```
///var title: String?
///var titleFont: UIFont
///var titleColor: UIColor
///var menuTitle: String?
///var menuOptions: [String]?
///var menuButtonImageName: String
///var alpha: CGFloat
///var backgroundColor: UIColor?
///var isHidden: Bool
///var isUserInteractionEnabled: Bool
///var tintColor: UIColor?
///```
public class CardPartTitleView : UIView, CardPartView {
	
    /// Label's title text
	public var title: String? {
		didSet {
			label.text = title
		}
	}
    /// CardParts theme titleFont by default
	public var titleFont: UIFont = CardParts.theme.titleFont {
		didSet {
			label.font = titleFont
		}
	}
    /// CardParts theme titleColor by default
	public var titleColor: UIColor = CardParts.theme.titleColor {
		didSet {
			label.textColor = titleColor
		}
	}
    /// menu title
	public var menuTitle: String?
    /// array of menu options
	public var menuOptions: [String]?
    /// image for menu button
    public var menuButtonImage: UIImage? = nil {
        didSet {
            if type == .titleWithMenu || type == .titleWithActionableButton {
                if let image = menuButtonImage {
                    button?.setImage(image, for: .normal)
                }
            }
        }
    }
    /// "arrowdown" by default
	public var menuButtonImageName: String = "arrowdown" {
		didSet {
			if type == .titleWithMenu || type == .titleWithActionableButton {
                menuButtonImage = UIImage(named: menuButtonImageName, in: Bundle(for: CardPartTitleView.self), compatibleWith: nil)
			}
		}
	}
    /// menu option observer
	public var menuOptionObserver: ((String, Int) -> Void)?
    /// callback for menu action
	public var menuActionableCallback: (()->())?
	
    /// CardParts theme titleViewMargs by default
	public var margins: UIEdgeInsets = CardParts.theme.titleViewMargins
	
	private let type: CardPartTitleType
    /// label
	public var label: UILabel
    /// button
	public var button: UIButton?
	
    /// initializes CardPartTitle of `CardPartTitleType`
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
    
    /// Required init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    /// Update constraints based on button or not
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
	
    /// Create and present menu
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
	
    /// Call callback for menu action
	@objc func actionableMenuTapped() {
		
		guard let action = menuActionableCallback else { return }
		
		action()
	}

}

extension Reactive where Base: CardPartTitleView {

	/// Updates titleView's title
    public var title: Binder<String?>{
		return Binder<String?>(self.base) { (titleView, title) -> () in
			titleView.title = title
		}
	}
	
	/// Updates titleView's titleFont
    public var titleFont: Binder<UIFont>{
		return Binder(self.base) { (titleView, titleFont) -> () in
			titleView.titleFont = titleFont
		}
	}
	
	/// Updates titleView's titleColor
    public var titleColor: Binder<UIColor>{
		return Binder(self.base) { (titleView, titleColor) -> () in
			titleView.titleColor = titleColor
		}
	}
	
	/// Updates titleView's menuTitle
    public var menuTitle: Binder<String?>{
		return Binder(self.base) { (titleView, menuTitle) -> () in
			titleView.menuTitle = menuTitle
		}
	}
	
	/// Updates titleView's menuOptions
    public var menuOptions: Binder<[String]?>{
		return Binder(self.base) { (titleView, menuOptions) -> () in
			titleView.menuOptions = menuOptions
		}
	}
	
	/// Updates titleView's menuButtonImageName
    public var menuButtonImageName: Binder<String>{
		return Binder(self.base) { (titleView, menuButtonImageName) -> () in
			titleView.menuButtonImageName = menuButtonImageName
		}
	}
    
    /// Updates titleView's menuButtonImage
    public var menuButtonImage: Binder<UIImage?>{
        return Binder(self.base) { (titleView, menuButtonImage) -> () in
            titleView.menuButtonImage = menuButtonImage
        }
    }
}
