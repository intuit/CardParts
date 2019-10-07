//
//  CardPartMapViewTests.swift
//  CardParts_Tests
//
//  Created by Michael VanDyke on 10/6/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import CoreLocation
import MapKit

@testable import CardParts

class CardPartMapViewTests: XCTestCase {
    
    let location1 = CLLocation(latitude: 37.430489, longitude: -122.096260)
    let location2 = CLLocation(latitude: 38.252666, longitude: -85.758453)
    let location3 = CLLocation(latitude: 49.282730, longitude: -123.120735)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLocationProperty() {
        let bag = DisposeBag()
        
        let cardPartMapView = CardPartMapView(type: .standard, location: location1, zoom: 10_000)
        let locationRelay = PublishRelay<CLLocation>()
        locationRelay.asObservable().bind(to: cardPartMapView.rx.location).disposed(by: bag)

        // CLLocation doesn't conform to Equatable so we just check to make sure the lat/long have changed.
        XCTAssertEqual(cardPartMapView.location.coordinate.latitude, location1.coordinate.latitude)
        XCTAssertEqual(cardPartMapView.location.coordinate.longitude, location1.coordinate.longitude)

        locationRelay.accept(location2)
        XCTAssertEqual(cardPartMapView.location.coordinate.latitude, location2.coordinate.latitude)
        XCTAssertEqual(cardPartMapView.location.coordinate.longitude, location2.coordinate.longitude)
        
        locationRelay.accept(location3)
        XCTAssertEqual(cardPartMapView.location.coordinate.latitude, location3.coordinate.latitude)
        XCTAssertEqual(cardPartMapView.location.coordinate.longitude, location3.coordinate.longitude)
    }
    
    func testMapTypeProperty() {
        let bag = DisposeBag()
        
        let cardPartMapView = CardPartMapView(type: .standard, location: location1, zoom: 10_000)
        let mapTypeRelay = PublishRelay<MKMapType>()
        mapTypeRelay.asObservable().bind(to: cardPartMapView.rx.mapType).disposed(by: bag)
        
        XCTAssertEqual(cardPartMapView.mapType, .standard)
        
        mapTypeRelay.accept(.hybrid)
        XCTAssertEqual(cardPartMapView.mapType, .hybrid)
    }
    
    func testZoomProperty() {
        let bag = DisposeBag()
        
        let cardPartMapView = CardPartMapView(type: .standard, location: location1, zoom: 10_000)
        let zoomRelay = PublishRelay<CardPartMapView.Meters>()
        zoomRelay.asObservable().bind(to: cardPartMapView.rx.zoom).disposed(by: bag)
        
        XCTAssertEqual(cardPartMapView.zoom, 10000)
        
        zoomRelay.accept(3000)
        XCTAssertEqual(cardPartMapView.zoom, 3000)
    }
}
