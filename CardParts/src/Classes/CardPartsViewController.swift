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

/// CardState
public enum CardState: Hashable {
    /// No state
    case none
    /// Loading
    case loading
    /// Empty
    case empty
    /// Has data
    case hasData
    /// Custom state
    case custom(String)
}

class CardStateData {
    var cardParts: [CardPartView] = []
    var constraints: [NSLayoutConstraint] = []
}

///CardPartsViewController implements the CardController protocol and builds its card UI by displaying one or more card part views using an MVVM pattern that includes automatic data binding. Each CardPartsViewController displays a list of CardPartView as its subviews. Each CardPartView renders as a row in the card. The CardParts framework implements several different types of CardPartView that display basic views, such as title, text, image, button, separator, etc. All CardPartView implemented by the framework are already styled to correctly match the applied themes UI guidelines.
///
///In addition to the card parts, a CardPartsViewController also uses a view model to expose data properties that are bound to the card parts. The view model should contain all the business logic for the card, thus keeping the role of the CardPartsViewController to just creating its view parts and setting up bindings from the view model to the card parts. A simple implementation of a CardPartsViewController based card might look like the following:
///```
///class TestCardController: CardPartsViewController  {
///
///    var viewModel = TestViewModel()
///    var titlePart = CardPartTitleView(type: .titleOnly)
///    var textPart = CardPartTextView(type: .normal)
///
///    override func viewDidLoad() {
///        super.viewDidLoad()
///
///        viewModel.title.asObservable().bind(to: titlePart.rx.title).disposed(by: bag)
///        viewModel.text.asObservable().bind(to: textPart.rx.text).disposed(by: bag)
///
///        setupCardParts([titlePart, textPart])
///    }
///}
///
///class TestViewModel {
///
///    var title = BehaviorRelay(value: "")
///    var text = BehaviorRelay(value: "")
///
///    init() {
///
///        // When these values change, the UI in the TestCardController
///        // will automatically update
///        title.accept("Hello, world!")
///        text.accept("CardParts is awesome!")
///    }
///}
///````
///The above example creates a card that displays two card parts, a title card part and a text part. The bind calls setup automatic data binding between view model properties and the card part view properties so that whenever the view model properties change, the card part views will automatically update with the correct data.
///
///The call to `setupCardParts` adds the card part views to the card. It takes an array of CardPartView that specifies which card parts to display, and in what order to display them.
open class CardPartsViewController : UIViewController, CardController {
    
    /// Default to false
    public var isEditable = false
	var vertContraints: [NSLayoutConstraint]?
	
    /// `.none` by default
	public var state: CardState = .none {
		didSet {
			updateState(oldState: oldValue, newState: state)
		}
	}
	
	var marginViews: [UIView: (UIView?, UIView?)] = [:]
        
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
	
    /// DisposeBag
	public let bag = DisposeBag()
    
    deinit {
        
        // Remove references to callbacks to ensure no mem-leak
        self.cardClickedCallback = [:]
    }
	
    /// ViewDidLoad
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Sets up card parts storing state data, and stacking cards vertically
    ///
    /// - Parameters:
    ///   - cardParts: Array of `CardPartView`
    ///   - forState: `CardState`
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
    
    
    /// Protocol conformance
    public func viewController() -> UIViewController {
        return self
    }

    /// InvalidateLayout
	public func invalidateLayout() {
		if let parent = parent as? CardsViewController {
			parent.invalidateLayout()
		}
	}
	
    /// Invalidate layout for any change from observables
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
    
    /// Triggers cardTapped delegate for `CardState`
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
	
    /// Updates cardPartsViewController state
	public var state: Binder<CardState>{
		return Binder(self.base) { (cardPartsViewController, state) -> () in
			cardPartsViewController.state = state
		}
	}
	
}

