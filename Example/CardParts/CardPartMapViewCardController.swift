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
    let cardPartTextField = CardPartTextField(format: .none)
    let cardPartMapView = CardPartMapView(type: .standard, location: CLLocation(latitude: 37.430489, longitude: -122.096260), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartMapView"
        cardPartTextField.placeholder = "Enter Address"
        cardPartMapView.intrensicHeight = 400 // Setting a custom height

        setupCardParts([
            cardPartTextView,
            cardPartTextField,
            cardPartMapView
        ])
        
        setupBindings()
    }
    
    private func setupBindings() {
        cardPartTextField.rx.text
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { $0 != nil && !$0!.isEmpty }
            .flatMap { self.viewModel.getLocation(from: $0!)}
            .catchError({ error -> Observable<CLLocation> in
                print("MapView Error: \(error)")
                return .just(self.cardPartMapView.location) // Returns previous value
            })
            .bind(to: cardPartMapView.rx.location)
            .disposed(by: bag)
        
        viewModel.zoomLevel
            .bind(to: cardPartMapView.rx.span)
            .disposed(by: bag)
    }
}

class ReactiveCardPartMapViewModel {
    
    var zoomLevel = BehaviorRelay<MKCoordinateSpan>(value: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
    init() {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(randomize), userInfo: nil, repeats: true)
    }
    
    @objc private func randomize() {
        switch Int.random(in: 0...2) {
        case 0:
            zoomLevel.accept(MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        case 1:
            zoomLevel.accept(MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        case 2:
            zoomLevel.accept(MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        default:
            ()
        }
    }
    
    /// Converts an address string to an observable stream of CLLocation
    func getLocation(from address: String) -> Observable<CLLocation> {
        return Observable<CLLocation>.create { observer in
            CLGeocoder().geocodeAddressString(address) { (placeMarks, error) in
                if let error = error { observer.onError(error) }
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
