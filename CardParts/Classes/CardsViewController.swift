//
//  CardsViewController.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/17/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct CardInfo: Equatable {
	static var nextId = idGenerator()

	var cardController: CardController
	var position: Int
	var id: Int
	
	init(card: CardController, position: Int) {
		self.cardController = card
		self.position = position
		self.id = CardInfo.nextId()
	}
	
	fileprivate static func idGenerator() -> () -> Int {
		var lastId = 0
		return {
			lastId += 1
			return lastId
		}
	}
	
	static func ==(lhs: CardInfo, rhs: CardInfo) -> Bool {
		return lhs.id == rhs.id
	}
}

open class CardsViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    let editButtonOffset : CGFloat = 24
    let editButtonHeight : CGFloat = 50
    let editButtonWidth : CGFloat = 50
    let editButtonImage = "budgets_disclosure_icon"

    var cardControllers = [CardInfo]()
	var bag = DisposeBag()
    
    // previous scrollview bounds
    var lastScrollViewBounds: CGRect?
    
    let kCardCellIndentifier = "CardCell"
    public var collectionView : UICollectionView!
    var layout : UICollectionViewFlowLayout!
    
    var savedContentInset: UIEdgeInsets = UIEdgeInsets.zero
    
    open override func viewDidLoad() {
        super.viewDidLoad()
 
        layout = UICollectionViewFlowLayout()
		if #available(iOS 10.0, *) {
			layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
		} else {
			layout.estimatedItemSize = CGSize(width: self.view.bounds.size.width, height: 1)
		}
		layout.minimumLineSpacing = CardParts.theme.cardsLineSpacing
		layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self

        collectionView.backgroundColor = UIColor.color(245, green: 245, blue: 245)
//        collectionView.register(CardCell.self, forCellWithReuseIdentifier: kCardCellIndentifier)
        collectionView.dataSource = self
		let insets = UIEdgeInsets(top: CardParts.theme.cardsViewContentInsetTop, left: 0, bottom: (tabBarController?.tabBar.bounds.size.height ?? 0) + layout.minimumLineSpacing * 2, right: 0)
        collectionView.contentInset = insets
		collectionView.scrollIndicatorInsets = insets
        self.view.addSubview(collectionView)

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView" : collectionView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView" : collectionView]))

    }
    
    // functionality that happens when the view appears
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // make sure that we set this as the first time we are checking for visibility
        lastScrollViewBounds = nil
        notifyCardsVisibility()
    }
	
    public func invalidateLayout() {
        DispatchQueue.main.async { [weak self] in
			let context = UICollectionViewFlowLayoutInvalidationContext()
			context.invalidateFlowLayoutAttributes = false
            self?.layout.invalidateLayout(with: context)
        }
    }

	public func loadCards(cards:[CardController]) {
		setCardControllers(cards: cards)
		
		registerCells(cards: cards)
		
		collectionView.reloadData()
		collectionView.collectionViewLayout.invalidateLayout()
	}

	private func setCardControllers(cards: [CardController]) {
		var cardInfos: [CardInfo] = []

		cardControllers.removeAll()

		for (position, card) in cards.enumerated() {
			
			let cardInfo = CardInfo(card: card, position: position)
			cardInfos.append(cardInfo)
			
			var cardVisible = true
			if let hiddenTrait = cardInfo.cardController as? HiddenCardTrait {
				cardVisible = !hiddenTrait.isHidden.value
			}
			if cardVisible {
				cardControllers.append(cardInfo)
			}
		}
		
		for cardInfo in cardInfos {
			if let hiddenTrait = cardInfo.cardController as? HiddenCardTrait {
				hiddenTrait.isHidden.asObservable().subscribe(onNext: { isHidden in
					DispatchQueue.main.async { [weak self] in
						self?.hideCard(cardInfo: cardInfo, isHidden: isHidden)
					}
				}).disposed(by: bag)
			}
		}
	}
	
	public func registerCells(cards: [CardController]) {
		cards.forEach {
			collectionView.register(CardCell.self, forCellWithReuseIdentifier: $0.hashString)
		}
	}

    public func reload(cards: [CardController]) {

        self.loadCards(cards: cards)
    }
	
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getCardControllerCount()
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cardController = getCardControllerForIndexPath(indexPath: indexPath)
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardController.hashString, for: indexPath) as! CardCell
		let viewController = cardController.viewController()

		if cell.cardContentView.subviews.count == 0 {
			
			var noTopBottomMargins = false
			if let noTopBottomMarginsCardTrait = cardController as? NoTopBottomMarginsCardTrait {
				noTopBottomMargins = noTopBottomMarginsCardTrait.requiresNoTopBottomMargins()
			}
			cell.requiresNoTopBottomMargins(noTopBottomMargins)
			
			var transparentCard = false
			if let transparentCardTrait = cardController as? TransparentCardTrait {
				transparentCard = transparentCardTrait.requiresTransparentCard()
			}
			cell.requiresTransparentCard(transparentCard: transparentCard)
			
            if let shadowCardTrait = cardController as? ShadowCardTrait {
                cell.addShadowToCard(shadowRadius: shadowCardTrait.shadowRadius(), shadowOpacity: shadowCardTrait.shadowOpacity(), shadowColor: shadowCardTrait.shadowColor())
            }
            
            if let roundedCardTrait = cardController as? RoundedCardTrait {
                cell.setCornerRadius(radius: roundedCardTrait.cornerRadius())
            }
            
            if let gradientCardTrait = cardController as? GradientCardTrait {
                cell.gradientColors = gradientCardTrait.gradientColors()
            }
            
            cell.cardContentView.subviews.forEach { $0.removeFromSuperview() }
			viewController.view.removeFromSuperview()
			
			let hasParent = viewController.parent != nil
			if !hasParent {
				addChildViewController(viewController)
			}
			
			cell.cardContentView.addSubview(viewController.view)
			viewController.view.translatesAutoresizingMaskIntoConstraints = false
			
			cell.cardContentView.removeConstraints(cell.cardContentConstraints)
			cell.cardContentConstraints.removeAll()
			
			let metrics = ["cardContentWidth": view.bounds.size.width - (CardParts.theme.cardCellMargins.left + CardParts.theme.cardCellMargins.right)]
            cell.cardContentConstraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: "H:|[view(cardContentWidth)]|", options: [], metrics: metrics, views: ["view" : viewController.view]))
			cell.cardContentConstraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view" : viewController.view]))
            			
			cell.cardContentView.addConstraints(cell.cardContentConstraints)
			if getEditModeForIndexPath(indexPath: indexPath) {
				let editButton = UIButton(frame: CGRect(x: view.bounds.size.width - editButtonOffset - editButtonWidth, y: 0, width: editButtonWidth, height: editButtonHeight))
				editButton.setImage(UIImage(named: editButtonImage, in: Bundle(for: CardsViewController.self), compatibleWith: nil), for: .normal)
				editButton.addTargetClosure { _ in
					if let editibalCardTrait = cardController as? EditableCardTrait {
						editibalCardTrait.onEditButtonTap()
					}
				}
				cell.contentView.addSubview(editButton)
			}
			if !hasParent {
				viewController.didMove(toParentViewController: self)
			}
		}
		cell.cardContentView.layoutIfNeeded()
		cell.cardContentView.updateConstraints()
		return cell
    }

	open func getCardControllerCount() -> Int {
		
		return cardControllers.count
	}

    open func getCardControllerForIndexPath(indexPath: IndexPath) -> CardController {
		
        return cardControllers[indexPath.row].cardController
    }
	
	func getEditModeForIndexPath(indexPath: IndexPath) -> Bool {
		
		if let editibalCardTrait = getCardControllerForIndexPath(indexPath: indexPath) as? EditableCardTrait {
			return editibalCardTrait.isEditable()
		}
		return false
	}

    func fromClassName(className : String) -> NSObject? {
        if let ns = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String {
            if let aClass = NSClassFromString(ns + "." + className) as? NSObject.Type {
                return aClass.init()
            }
        }
        return nil
    }
	
	func hideCard(cardInfo: CardInfo, isHidden: Bool) {
		
//		let oldCardControllers = cardControllers
		
		if isHidden {
			if let index = cardControllers.index(of: cardInfo) {
				cardControllers.remove(at: index)
			}
		} else {
			if cardControllers.index(of: cardInfo) == nil {
				cardControllers.append(cardInfo)
				cardControllers = cardControllers.sorted { $0.position < $1.position }
			}
		}
		collectionView.reloadData()
		collectionView.collectionViewLayout.invalidateLayout()
//		collectionView.animateItemChanges(oldData: oldCardControllers, newData: cardControllers)
	}
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIResponder.first?.resignFirstResponder()
    }
}

extension CardsViewController {
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listenToKeyboardShowHideNotifications()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopListeningToKeyboardShowHideNotifications()
    }
    
    public func listenToKeyboardShowHideNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public func stopListeningToKeyboardShowHideNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc open func keyboardWillShow(notification: Notification) {
        guard var keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let keyboardCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
              let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let responder = UIResponder.first as? UIView
        else { return }
        
        keyboardRect = self.view.convert(keyboardRect, from: nil)
        
        let scrollViewKeyboardIntersection = collectionView.frame.intersection(keyboardRect)
        let newContentInsets = UIEdgeInsetsMake(0, 0, scrollViewKeyboardIntersection.size.height, 0)
        
        savedContentInset = collectionView.contentInset
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(keyboardDuration)
        if let animationCurve = UIViewAnimationCurve.init(rawValue: keyboardCurve) {
            UIView.setAnimationCurve(animationCurve)
        }
        collectionView.contentInset = newContentInsets
        collectionView.scrollIndicatorInsets = newContentInsets
        
        var controlFrameInScrollView = collectionView.convert(responder.bounds, from: responder)
        controlFrameInScrollView = controlFrameInScrollView.insetBy(dx: 0, dy: -10.0)
        let controlVisualOffsetToTopOfScrollview = controlFrameInScrollView.origin.y - collectionView.contentOffset.y
        let controlVisualBottom = controlVisualOffsetToTopOfScrollview + controlFrameInScrollView.size.height
        // visible part of scrollview not hidden by keyboard:
        let scrollViewVisibleHeight = collectionView.frame.size.height - scrollViewKeyboardIntersection.size.height
        
        if controlVisualBottom > scrollViewVisibleHeight { // keyboard will hide control in question
            var newContentOffset = collectionView.contentOffset
            newContentOffset.y += controlVisualBottom - scrollViewVisibleHeight
            newContentOffset.y = min(newContentOffset.y, collectionView.contentSize.height - scrollViewVisibleHeight)
            collectionView.setContentOffset(newContentOffset, animated: false)
        } else if controlFrameInScrollView.origin.y < collectionView.contentOffset.y {
            // control not fully visible
            var newContentOffset = collectionView.contentOffset
            newContentOffset.y = controlFrameInScrollView.origin.y
            collectionView.setContentOffset(newContentOffset, animated: false)
        }
        
        UIView.commitAnimations()
        
    }
 
    @objc open func keyboardWillHide(notification: Notification) {
        guard let keyboardCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
              let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else { return }

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(keyboardDuration)
        if let animationCurve = UIViewAnimationCurve.init(rawValue: keyboardCurve) {
            UIView.setAnimationCurve(animationCurve)
        }
        collectionView.contentInset = savedContentInset
        collectionView.scrollIndicatorInsets = savedContentInset
        UIView.commitAnimations()

    }
}

// scroll view delegate extension. This allows subclasses of CardsViewController to implement these scroll view delegate methods
extension CardsViewController {
    
    // calls visibility delegates as needed with the appropriate frame
    open func notifyCardsVisibility() {
        if CardUtils.isSignificantScroll(lastScrollBounds: lastScrollViewBounds, currentScrollBounds: collectionView.bounds, threshold: 0.0) {
            // for all visible cells go through and calaculate visibility and pass along to CardPartsViewControllers
            collectionView.visibleCells.flatMap { ($0 as? CardCell) }.forEach { (cell) in
                guard let indexPath = collectionView.indexPath(for: cell) else { return }
                let cardController = getCardControllerForIndexPath(indexPath: indexPath)
                
                if let vc = cardController as? CardPartsViewController {
                    vc.cardVisibility(percentVisible: CardUtils.cardVisibility(containerFrame: collectionView.bounds, cardFrame: cell.frame))
                }
            }
        }
        
        lastScrollViewBounds = collectionView.bounds
    }
    
    // calls for visibility of card when the scroll view scrolls
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        notifyCardsVisibility()
    }
}
