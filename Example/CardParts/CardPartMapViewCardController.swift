//
//  CardPartMapViewCardController.swift
//  CardParts_Example
//
//  Created by Michael VanDyke on 10/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CardParts
import RxCocoa
import RxSwift
import MapKit

class CardPartMapViewCardController: CardPartsViewController {
    
    let viewModel = ReactiveCardPartMapViewModel()
    
    let cardPartTextView = CardPartTextView(type: .title)
    let cardPartMapView = CardPartMapView(location: CLLocation(latitude: 37.430490, longitude: -122.096260), type: .standard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartMapView!"
       
        cardPartMapView.addConstraint(NSLayoutConstraint(item: cardPartMapView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 300))
                        
        setupCardParts([cardPartTextView, cardPartMapView])
        
        cardPartMapView.mapView.mapType = .hybrid
        
        viewModel.location
            .bind(to: cardPartMapView.rx.location)
            .disposed(by: bag)
    }
}

class ReactiveCardPartMapViewModel {

    var location = BehaviorRelay(value: CLLocation(latitude: 37.430490, longitude: -122.096260))
    var spanInMeters = BehaviorRelay<Double>(value: 1000)

    init() {
        randomise()
    }
    
    func randomise() {
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.random), userInfo: nil, repeats: true)
    }
    
    @objc func random() {
        switch Int.random(in: 0...2) {
        case 0:
            location.accept(CLLocation(latitude: 37.430490, longitude: -122.096260))
        case 1:
            location.accept(CLLocation(latitude: 38.252666, longitude: -85.758453))
        case 2:
            location.accept(CLLocation(latitude: 40.712776, longitude: -74.005974))
        default:
            return
        }
    }
    
}
