//
//  CardVisibilityDelegate.swift
//  CardParts
//
//  Created by Tumer, Deniz on 5/23/18.
//

/*
 * This protocol handles passing data about the visibility of a card
 * from an instance of a CardsViewController to the card itself
 */
@objc public protocol CardVisibilityDelegate {
    
    /*
     * Notifies a card of its visibility.
     *
     * @param percentVisible - percentage of the card that is visible in the list of cards
     */
    @objc optional func cardVisibility(percentVisible: CGFloat)
}
