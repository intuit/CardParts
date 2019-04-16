//
//  CardPartsViewController.swift
//  CardParts2
//
//  Created by Kier, Tom on 1/17/17.
//  Copyright © 2017 Kier, Tom. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum CardState: Hashable {
    case none
    case loading
    case empty
    case hasData
    case custom(String)
}

class CardStateData {
    var cardParts: [CardPartView] = []
    var constraints: [NSLayoutConstraint] = []
}

open class CardPartsViewController : UIViewController, CardController {
    
    public var isEditable = false
	var vertContraints: [NSLayoutConstraint]?
	
	public var state: CardState = .none {
		didSet {
			updateState(oldState: oldValue, newState: state)
		}
	}
	
	var marginViews: [UIView: (UIView?, UIView?)] = [:]
    
    // visibility ratios for the card
    var cardVisibilityRatio: CGFloat = -1.0
    var containerCoverageRatio: CGFloat = -1.0
    
    // MARK: Clickable traits
    private var cardTapGesture: UITapGestureRecognizer?
    
    private var cardClickedCallback: [CardState: (()->())] = [:] {
        
        didSet {
            // We don't have a tap gesture setup, let's add
            guard cardTapGesture == nil else { return }
            
            cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cardWasTapped(sender:)))
            
            guard let tap = cardTapGesture else { return }
            
            self.view.addGestureRecognizer(tap)
        }
    }
	
	private var cardParts:[CardState : CardStateData] = [:]
	
	public let bag = DisposeBag()
    
    deinit {
        
        // Remove references to callbacks to ensure no mem-leak
        self.cardClickedCallback = [:]
    }
	
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

	public func setupCardParts(_ cardParts:[CardPartView], forState: CardState = .none) {
		
        let stateData = CardStateData()
        stateData.cardParts = cardParts
		self.cardParts[forState] = stateData
        
        var prevCardPart: UIView = view
        var padding: CGFloat = 0

        for cardPart in cardParts {
            
            cardPart.view.translatesAutoresizingMaskIntoConstraints = false
			
            padding += cardPart.margins.top
            
            if let cardViewController = cardPart.viewController {
                addChild(cardViewController)
                view.addSubview(cardPart.view)
                cardViewController.didMove(toParent: self)
            } else {
                view.addSubview(cardPart.view)
            }
			
			let metrics = ["leftMargin" : cardPart.margins.left, "rightMargin" : cardPart.margins.right]
            stateData.constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[cardPartView]-rightMargin-|", options: [], metrics: metrics, views: ["cardPartView" : cardPart.view!]))
            if prevCardPart == view {
                stateData.constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[cardPartView]", options: [], metrics: ["padding" : padding], views: ["cardPartView" : cardPart.view!]))
            } else {
                stateData.constraints.append(NSLayoutConstraint(item: cardPart.view!, attribute: .top, relatedBy: .equal, toItem: prevCardPart, attribute: .bottom, multiplier: 1.0, constant: padding))
            }

            prevCardPart = cardPart.view
            padding = cardPart.margins.bottom
        }
        
        stateData.constraints.append(NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: prevCardPart, attribute: .bottom, multiplier: 1.0, constant: padding))
        
        if forState == self.state {
            view.addConstraints(stateData.constraints)
        } else {
            removeCardPartsForState(forState)
        }
    }
    
    
    public func viewController() -> UIViewController {
        return self
    }

	public func invalidateLayout() {
		if let parent = parent as? CardsViewController {
			parent.invalidateLayout()
		}
	}
	
	public func invalidateLayout<T>(onChanges variables: [BehaviorRelay<T>]) {
		for variable in variables {
			variable.asObservable().subscribe(onNext: { [weak self] _ in
				self?.invalidateLayout()
            }).disposed(by: bag)
		}
	}
	
	private func updateState(oldState: CardState, newState: CardState) {
		if oldState == newState { return }
        removeCardPartsForState(oldState)
        addCardPartsForState(newState)
		invalidateLayout()
	}
    
    public func cardTapped(forState state: CardState = .none, action: @escaping (()->())) {
        self.cardClickedCallback[state] = action
    }
    
    private func addCardPartsForState(_ state: CardState) {
        if let stateData = cardParts[state] {
            stateData.cardParts.forEach {
                if let cardViewController = $0.viewController {
                    addChild(cardViewController)
                    view.addSubview($0.view)
                    cardViewController.didMove(toParent: self)
                } else {
                    view.addSubview($0.view)
                }
            }
            view.addConstraints(stateData.constraints)
        }
    }

    private func removeCardPartsForState(_ state: CardState) {
        if let stateData = cardParts[state] {
            stateData.cardParts.forEach {
                if let cardViewController = $0.viewController {
                    cardViewController.willMove(toParent: nil)
                }
            }
            view.removeConstraints(stateData.constraints)
            stateData.cardParts.forEach {
                if let cardViewController = $0.viewController {
                    cardViewController.view.removeFromSuperview()
                    cardViewController.removeFromParent()
                } else {
                    $0.view.removeFromSuperview()
                }
            }
        }
    }
}

extension CardPartsViewController {
    
    @objc private func cardWasTapped(sender: UITapGestureRecognizer? = nil) {

        guard let desiredAction = self.cardClickedCallback[self.state] else { return }
        
        desiredAction()
    }
}

extension Reactive where Base: CardPartsViewController {
	
	public var state: Binder<CardState>{
		return Binder(self.base) { (cardPartsViewController, state) -> () in
			cardPartsViewController.state = state
		}
	}
	
}

