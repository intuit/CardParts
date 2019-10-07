//
//  CardPartMapView.swift
//  CardParts
//
//  Created by Michael VanDyke on 10/5/19.
//

import Foundation
import MapKit
import RxCocoa
import RxSwift

public class CardPartMapView: UIView, CardPartView {
    public var mapType: MKMapType {
        didSet {
            updateMap()
        }
    }
    
    public var location: CLLocation {
        didSet {
            updateMap()
        }
    }
    
    public var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1) {
        didSet {
            updateMap()
        }
    }
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    public var mapView: MKMapView
    
    public init(type: MKMapType, location: CLLocation, span: MKCoordinateSpan?) {
        mapView = MKMapView(frame: .zero)
        self.mapType = type
        self.location = location
        
        if let span = span {
            self.span = span
        }
        
        super.init(frame: .zero)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
        setNeedsUpdateConstraints()
        updateMap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateConstraints() {
        let constraints = [
            NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        ]

        self.addConstraints(constraints)
        super.updateConstraints()
    }
    
    private func updateMap() {
        mapView.mapType = mapType

        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: span), animated: true)
    }
}

extension Reactive where Base: CardPartMapView {
    
    public var location: Binder<CLLocation> {
        return Binder(self.base) { (mapView, location) -> () in
            mapView.location = location
        }
    }
    
    public var mapType: Binder<MKMapType> {
        return Binder(self.base) { (mapView, mapType) -> () in
            mapView.mapType = mapType
        }
    }
    
    public var span: Binder<MKCoordinateSpan> {
        return Binder(self.base) { (mapView, span) -> () in
            mapView.span = span
        }
    }

}
