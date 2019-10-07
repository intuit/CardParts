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
import CoreLocation
import MapKit

class CardPartMapViewCardController: CardPartsViewController {
    
    let viewModel = ReactiveCardPartMapViewModel()
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let cardPartTextField = CardPartTextField(format: .zipcode)
    let cardPartMapView = CardPartMapView(type: .standard, location: CLLocation(latitude: 37.430489, longitude: -122.096260), zoom: 10_000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartMapView"
        cardPartTextField.placeholder = "Enter Zipcode"
 
        setupCardParts([
            cardPartTextView,
            cardPartTextField,
            cardPartMapView
        ])
        
        setupConstraints()
        setupBindings()
    }
    
    private func setupConstraints() {
        cardPartMapView.addConstraint(NSLayoutConstraint(item: cardPartMapView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 300))
    }
    
    private func setupBindings() {
        
        cardPartTextField.rx.text
            .distinctUntilChanged()
            .debounce(1, scheduler: MainScheduler.instance)
            .filter { $0 != nil }
            .flatMap { self.viewModel.getLocation(from: $0!) }
            .bind(to: cardPartMapView.rx.location)
            .disposed(by: bag)

        viewModel.zoom
            .bind(to: cardPartMapView.rx.zoom)
            .disposed(by: bag)
    }
}

class ReactiveCardPartMapViewModel {
    
    // Outputs
    var zoom = BehaviorRelay<CardPartMapView.Meters>(value: 10_000)
    
    /// Converts an address string to an observable stream of CLLocation
    func getLocation(from address: String) -> Observable<CLLocation> {
        return Observable<CLLocation>.create { observer in
            CLGeocoder().geocodeAddressString(address) { (placeMarks, _) in
                if let placeMarks = placeMarks,
                   let location = placeMarks.first?.location {
                    observer.onNext(location)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
}
