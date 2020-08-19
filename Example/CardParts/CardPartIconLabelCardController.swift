//
//  CardPartIconLabelCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 8/21/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts
import RxSwift
import RxCocoa

class CardPartIconLabelCardController: CardPartsViewController {
    
     var viewModel = ReactiveCardPartIconViewModel()
    
    override func viewDidLoad() {
        
        let alignment: CardPartIconLabel.VerticalPosition = .center
        
        let stackView = CardPartStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        for index in 0..<5 {

            let iconLabel = CardPartIconLabel()
            iconLabel.verticalPadding = 10
            iconLabel.horizontalPadding = 10
            iconLabel.font = UIFont.systemFont(ofSize: 12)
            if #available(iOS 13.0, *) {
                iconLabel.textColor = UIColor.label
                iconLabel.tintColor = UIColor.label
                iconLabel.backgroundColor = UIColor(dynamicProvider: { traitCollection in
                    if traitCollection.userInterfaceStyle == .dark {
                        return UIColor(red: 27.0 / 255.0, green: 223.0 / 255.0, blue: 0, alpha: 0.16)
                    }
                    return UIColor(red: 16.0 / 255.0, green: 128.0 / 255.0, blue: 0, alpha: 0.16)
                })
            } else {
                iconLabel.textColor = UIColor.black
                iconLabel.tintColor = UIColor.black
                iconLabel.backgroundColor = UIColor(red: 16.0 / 255.0, green: 128.0 / 255.0, blue: 0, alpha: 0.16)
            }
            iconLabel.numberOfLines = 0
            iconLabel.iconPadding = 5
            iconLabel.layer.cornerRadius = 8.0
            iconLabel.icon = UIImage(named: "themeIcon")?.withRenderingMode(.alwaysTemplate)
            
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
            
            if index == 2 {
                viewModel.labelText.asObservable().bind(to: iconLabel.rx.labelText).disposed(by: bag)
                viewModel.icon.asObservable().bind(to: iconLabel.rx.icon).disposed(by: bag)
                 invalidateLayout(onChanges: [viewModel.icon])
                
                iconLabel.tapIconGestureRecognizer(action: {
                    print("Second Index Image Tapped")
                })
            }
        }

        setupCardParts([stackView])
    }
}

class ReactiveCardPartIconViewModel {
    
    var labelText = BehaviorRelay(value: "Defaul Label")
    var icon:BehaviorRelay<UIImage?> = BehaviorRelay(value:  UIImage(named: ""))
    
    init() {
        startTimer()
    }
    
    func startTimer() {
        icon.accept(UIImage(named: "cardIcon"))
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.randomise), userInfo: nil, repeats: true)
    }
    
    @objc func randomise() {
        switch arc4random() % 1 {
        case 0:
            labelText.accept("CardParts is reactive based library")
        default:
            return
        }
    }
    
}
