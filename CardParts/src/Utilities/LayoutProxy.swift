//
//  LayoutProxy.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 8/5/19.
//  Copyright © 2019 Intuit. All rights reserved.
import Foundation
import UIKit

protocol LayoutAnchor {
    /**
     requirement methods as part of layout constraints
     
     - parameters:
     - Self: refers to the eventual type that conforms to protocol,only available in a protocol or as the result of a method in a class.
     - constant: constant offset for the constraint
     */
    
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor { }

/**
 This new type is simply be a wrapper around anchor property, which allows to refer in a simple manner.
 */

struct LayoutProperty<Anchor: LayoutAnchor> {
    fileprivate let anchor: Anchor
}

/**
 API for using layout properties to add constraints
 */
extension LayoutProperty {
    
    func equal(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) {
        anchor.constraint(equalTo: otherAnchor, constant: constant).isActive = true
    }
    
    func greaterThanOrEqual(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) {
        anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant).isActive = true
    }
    
    func lessThanOrEqual(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) {
        anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant).isActive = true
    }
}

/**
 Provides an object that will acts a proxy for the view that we're currenlty defining layout for.
 */

public class LayoutProxy {
    lazy var leading = property(with: view.leadingAnchor)
    lazy var trailing = property(with: view.trailingAnchor)
    lazy var top = property(with: view.topAnchor)
    lazy var bottom = property(with: view.bottomAnchor)
    lazy var width = property(with: view.widthAnchor)
    lazy var height = property(with: view.heightAnchor)
    lazy var centerX = property(with: view.centerXAnchor)
    lazy var centerY = property(with: view.centerYAnchor)
    
    private let view: UIView
    
    fileprivate init(view: UIView) {
        self.view = view
    }
    
    private func property<A:LayoutAnchor>(with anchor: A) -> LayoutProperty<A> {
        return LayoutProperty(anchor: anchor)
    }
}

extension UIView {
    func layout(using closure: @escaping (LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(LayoutProxy(view: self))
    }
}

/**
 combines the layout anchors and a constant in to a tuple.
 for statement `button.widthAnchor + 20.0`
 - parameters:
 - lhs = individual anchor property for eg : button.widthAnchor
 - rhs = constant value for eg: 20.0
 */
func +<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, rhs)
}

/**
 combines layout anchors and a constant in to a tuple.
 for statement `button.heightAnchor - 20.0`
 
 - parameters:
 - lhs = individual anchor property (`button.widthAnchor`)
 - rhs = constant value (`20.0`)
 */
func -<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, -rhs)
}

/**
 equality comparision of wrapped anchor with tuple properties ( individual anchor , constant )
 for statement : `label.top == button.widthAnchor + 20.0`
 
 - parameters:
 - lhs = wrapped anchor property (`label.top`)
 - rhs = individual anchor and constant (`button.widthAnchor`, `20.0`)
 */
func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) {
    lhs.equal(to: rhs.0, offsetBy: rhs.1)
}

/**
 equality comparision of wrapped anchor property with individual anchor
 for statement : `label.top == button.widthAnchor`
 
 - parameters:
 - lhs = wrapped anchor property (`label.top`)
 - rhs = individual anchor (`button.widthAnchor`)
 */
func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.equal(to: rhs)
}

/**
 greater than equality comparision of wrapped anchor with tuple properties ( individual anchor , constant )
 for statement : `label.top >= button.widthAnchor + 20.0`
 
 - parameters:
 - lhs = wrapped anchor property (`label.top`)
 - rhs = individual anchor and constant (`button.widthAnchor`, `20.0`)
 */
func >=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

/**
 greater than equality comparision of wrapped anchor property with individual anchor
 for statement : `label.top >= button.widthAnchor`
 
 - parameters:
 - lhs = wrapped anchor property (`label.top`)
 - rhs = individual anchor (`button.widthAnchor`)
 */
func >=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.greaterThanOrEqual(to: rhs)
}

/**
 less than equality comparision of wrapped anchor with tuple properties ( individual anchor , constant )
 for statement : `label.top <= button.widthAnchor + 20.0`
 
 - parameters:
 - lhs = wrapped anchor property (`label.top`)
 - rhs = individual anchor and constant (`button.widthAnchor`, `20.0`)
 */
func <=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

/**
 less than equality comparision of wrapped anchor property with individual anchor
 for statement : `label.top <= button.widthAnchor`
 
 - parameters:
 - lhs = wrapped anchor property (`label.top`)
 - rhs = individual anchor (`button.widthAnchor`)
 */
func <=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.lessThanOrEqual(to: rhs)
}
