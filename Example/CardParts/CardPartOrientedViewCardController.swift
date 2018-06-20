//
//  CardPartOrientedViewCardController.swift
//  CardParts_Example
//
//  Created by Tumer, Deniz on 6/13/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartOrientedViewCardController: CardPartsViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        startRandomHides()
    }
    
    func startRandomHides() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.toggleOrientation), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup oriented elements
        setupCardParts([getTopOrientedContainer()], forState: .empty)
        setupCardParts([getBottomOrientedContainer()], forState: .hasData)
        
        state = .hasData
    }
    
    // get top container with elements
    private func getTopOrientedContainer() -> CardPartView {
        // container for containing the top oriented views
        let topContainer = CardPartStackView()
        topContainer.axis = .horizontal
        topContainer.distribution = .fillProportionally
        
        let cardPartTextView = CardPartTextView(type: .normal)
        let cardPartTextView2 = CardPartTextView(type: .normal)
        let cardPartTextView3 = CardPartTextView(type: .normal)
        
        cardPartTextView.text = "This is a label with text"
        cardPartTextView2.text = "This is a second label with text"
        cardPartTextView3.text = "This is a third label with text"
        
        // top oriented card parts
        let topOrientedCardPart = CardPartOrientedView(cardParts: [cardPartTextView, cardPartTextView2, cardPartTextView3], orientation: .top)
        
        // add views to container
        topContainer.addArrangedSubview(topOrientedCardPart)
        topContainer.addArrangedSubview(getLongStackView())
        
        return topContainer
    }
    
    // get bottom oriented container with elements
    private func getBottomOrientedContainer() -> CardPartView {
        // container for containing the bottom oriented views
        let bottomContainer = CardPartStackView()
        bottomContainer.axis = .horizontal
        bottomContainer.distribution = .fillProportionally
        
        let cardPartTextView = CardPartTextView(type: .normal)
        let cardPartTextView2 = CardPartTextView(type: .normal)
        let cardPartTextView3 = CardPartTextView(type: .normal)
        
        cardPartTextView.text = "This is a label with text"
        cardPartTextView2.text = "This is a second label with text"
        cardPartTextView3.text = "This is a third label with text"
        
        // bottom oriented card parts
        let bottomOrientedCardPart = CardPartOrientedView(cardParts: [cardPartTextView, cardPartTextView2, cardPartTextView3], orientation: .bottom)
        
        // add views to container
        bottomContainer.addArrangedSubview(bottomOrientedCardPart)
        bottomContainer.addArrangedSubview(getLongStackView())
        
        return bottomContainer
    }
    
    // get a stack view full of a bunch of elements
    private func getLongStackView() -> UIView {
        let stackView = CardPartStackView()
        stackView.axis = .vertical
        
        for ndx in 1...7 {
            let cardPartTextLabel = CardPartTextView(type: .normal)
            cardPartTextLabel.text = "This is a label with text \(ndx)"
            
            stackView.addArrangedSubview(cardPartTextLabel)
        }
        
        return stackView
    }
    
    @objc func toggleOrientation() {
        if state == .empty {
            state = .hasData
        }
        else {
            state = .empty
        }
    }
}
