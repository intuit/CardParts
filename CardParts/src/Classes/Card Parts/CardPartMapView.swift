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
    /// Calls updateMap on set
    public var mapType: MKMapType {
        didSet {
            updateMap()
        }
    }
    
    /// Calls updateMap on set
    public var location: CLLocation {
        didSet {
            updateMap()
        }
    }
    
    /// Calls updateMap on set
    public var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1) {
        didSet {
            updateMap()
        }
    }
    
    /// CardParts theme cardPartMargins by default
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    /// The instance of MKMapView used inside of the CardPartMapView
    public var mapView: MKMapView
    
    /// The height of the CardPartMapView. Default is 300 points. Override this to set a custom height.
    open var intrensicHeight: CGFloat = 300 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    /// Initializes map of type at location using span
    ///
    /// - Parameters:
    ///   - type: MKMapTyoe
    ///   - location: CLLocation
    ///   - span: (optional) MKCoordinateSpan
    public init(type: MKMapType, location: CLLocation, span: MKCoordinateSpan?) {
        mapView = MKMapView(frame: .zero)
        self.mapType = type
        self.location = location
        
        if let span = span {
            self.span = span
        }
        
        super.init(frame: .zero)
        
        addSubview(mapView)
        setupConstraints()
        setNeedsUpdateConstraints()
        updateMap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates height using intrensicHeight
    public override func updateConstraints() {
        if let heightConstraint = constraints.first(where: { $0.identifier == "CPMVHeight" }) {
            heightConstraint.constant = self.intrensicHeight
        }
        super.updateConstraints()
    }
    
    /// Setup the initial constraints
    private func setupConstraints() {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: intrensicHeight)
        heightConstraint.identifier = "CPMVHeight"
        self.addConstraint(heightConstraint)

        mapView.layout {
            $0.top == self.topAnchor
            $0.leading == self.leadingAnchor
            $0.trailing == self.trailingAnchor
            $0.bottom == self.bottomAnchor
        }
    }
    
    /// Update the map with any new changes
    private func updateMap() {
        mapView.mapType = mapType

        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: span), animated: true)
    }
}

extension Reactive where Base: CardPartMapView {
    
    /// Updates mapView's location
    public var location: Binder<CLLocation> {
        return Binder(self.base) { (mapView, location) -> () in
            mapView.location = location
        }
    }
    
    /// Updates mapView's mapType
    public var mapType: Binder<MKMapType> {
        return Binder(self.base) { (mapView, mapType) -> () in
            mapView.mapType = mapType
        }
    }
    
    /// Update mapView's span
    public var span: Binder<MKCoordinateSpan> {
        return Binder(self.base) { (mapView, span) -> () in
            mapView.span = span
        }
    }

}
