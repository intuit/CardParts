//
//  CardPartTextFieldCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts

class CardPartTextFieldCardController: CardPartsViewController {
    
    let cardPartTextView1 = CardPartTextView(type: .normal)
    let cardPartTextView2 = CardPartTextView(type: .normal)
    let cardPartTextView3 = CardPartTextView(type: .normal)
    let cardPartTextView4 = CardPartTextView(type: .normal)
    let cardPartTextView5 = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cardParts: [CardPartView] = []
        
        cardPartTextView1.text = "This is a CardPartTextField with format .phone"
        cardParts.append(cardPartTextView1)
        
        let cardPartTextFieldPhone = CardPartTextField(format: .phone)
        cardPartTextFieldPhone.keyboardType = .numberPad
        cardPartTextFieldPhone.placeholder = "(555)-555-5555"
        cardParts.append(cardPartTextFieldPhone)
        cardParts.append(CardPartSpacerView(height: 10))
        
        cardPartTextView2.text = "This is a CardPartTextField with format .currency"
        cardParts.append(cardPartTextView2)
        
        let cardPartTextFieldCurrency = CardPartTextField(format: .currency(maxLength: 6))
        cardPartTextFieldCurrency.keyboardType = .numberPad
        cardPartTextFieldCurrency.placeholder = "$120"
        cardParts.append(cardPartTextFieldCurrency)
        cardParts.append(CardPartSpacerView(height: 10))
        
        cardPartTextView3.text = "This is a CardPartTextField with format .zipcode"
        cardParts.append(cardPartTextView3)
        
        let cardPartTextFieldZipcode = CardPartTextField(format: .zipcode)
        cardPartTextFieldZipcode.keyboardType = .numberPad
        cardPartTextFieldZipcode.placeholder = "90007"
        cardParts.append(cardPartTextFieldZipcode)
        cardParts.append(CardPartSpacerView(height: 10))
        
        cardPartTextView4.text = "This is a CardPartTextField with format .ssn"
        cardParts.append(cardPartTextView4)
        
        let cardPartTextFieldSSN = CardPartTextField(format: .ssn)
        cardPartTextFieldSSN.keyboardType = .numberPad
        cardPartTextFieldSSN.placeholder = "555-55-5555"
        cardParts.append(cardPartTextFieldSSN)
        cardParts.append(CardPartSpacerView(height: 10))
        
        cardPartTextView5.text = "This is a CardPartTextField with format .none"
        cardParts.append(cardPartTextView5)
        
        let cardPartTextFieldNone = CardPartTextField(format: .none)
        cardPartTextFieldNone.keyboardType = .default
        cardPartTextFieldNone.placeholder = "CardParts is the best"
        cardParts.append(cardPartTextFieldNone)
        
        setupCardParts(cardParts)
    }
}
