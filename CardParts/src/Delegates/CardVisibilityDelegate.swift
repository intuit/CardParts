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
    
    /**
     Notifies a card of the ratio that the card or screen is visible at any given time.
     
     - Parameter cardVisibilityRatio: The ratio that the card is visible in the container
     - Parameter containerCoverageRatio: The ratio of the screen that is taken up by the card
     */
    @objc optional func cardVisibility(cardVisibilityRatio: CGFloat, containerCoverageRatio: CGFloat)
}
