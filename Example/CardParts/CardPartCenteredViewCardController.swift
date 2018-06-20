//
//  CardPartCenteredViewCardController.swift
//  CardParts_Example
//
//  Created by Tumer, Deniz on 6/20/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartCenteredViewCardController: CardPartsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let separator = CardPartVerticalSeparatorView()
        
        let leftStack = CardPartStackView()
        leftStack.axis = .vertical
        leftStack.spacing = 10
        
        let rightStack = CardPartStackView()
        rightStack.axis = .vertical
        rightStack.spacing = 10
        
        let textView = CardPartTextView(type: .normal)
        textView.text = "This is a label with text"
        let textView2 = CardPartTextView(type: .normal)
        textView2.text = "This is a second label with text"
        
        let textView3 = CardPartTextView(type: .normal)
        textView3.text = "This is a third label with text"
        let textView4 = CardPartTextView(type: .normal)
        textView4.text = "This is a fourth label with text"
        
        leftStack.addArrangedSubview(textView)
        leftStack.addArrangedSubview(textView2)
        
        rightStack.addArrangedSubview(textView3)
        rightStack.addArrangedSubview(textView4)
        
        let centeredView = CardPartCenteredView(leftView: leftStack, centeredView: separator, rightView: rightStack)
        setupCardParts([centeredView])
    }
}
