//
//  CardPartIconLabelCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 8/21/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts

class CardPartIconLabelCardController: CardPartsViewController {
    
    override func viewDidLoad() {
        
        let alignment: CardPartIconLabel.VerticalPosition = .center
        
        let stackView = CardPartStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        for index in 0...5 {

            let iconLabel = CardPartIconLabel()
            iconLabel.verticalPadding = 10
            iconLabel.horizontalPadding = 10
            iconLabel.backgroundColor = UIColor(red: 16.0 / 255.0, green: 128.0 / 255.0, blue: 0, alpha: 0.16)
            iconLabel.font = UIFont.systemFont(ofSize: 12)
            iconLabel.textColor = UIColor.black
            iconLabel.numberOfLines = 0
            iconLabel.iconPadding = 5
            iconLabel.icon = UIImage(named: "cardIcon")
            
            switch index {
            case 0:
                iconLabel.text = "Card icon on left,text is left"
                iconLabel.textAlignment = .left
                iconLabel.iconPosition = ( .left, alignment )
                
            case 1:
                iconLabel.text = "Card icon on right,text is left"
                iconLabel.textAlignment = .left
                iconLabel.iconPosition = ( .right, alignment )
                
            case 2:
                iconLabel.text = "Card icon on left,text is right"
                iconLabel.textAlignment = .right
                iconLabel.iconPosition = (.left, alignment)
                
            case 3:
                iconLabel.text = "Card icon on right,text is right"
                iconLabel.textAlignment = .right
                iconLabel.iconPosition = (.right, alignment)
                
            case 4:
                iconLabel.text = "Card icon on left,text is center"
                iconLabel.textAlignment = .center
                iconLabel.iconPosition = (.left, alignment)
                
            case 5:
                iconLabel.text = "Card icon on right,text is center"
                iconLabel.textAlignment = .center
                iconLabel.iconPosition = (.right, alignment)
                
            default:
                break
            }
            
            stackView.addArrangedSubview(iconLabel)
        }
        
        setupCardParts([stackView])
    }
}
