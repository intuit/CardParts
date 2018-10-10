//
//  CardUtils.swift
//  CardParts
//
//  Created by Tumer, Deniz on 5/23/18.
//

import Foundation

/*
 * Defines utility methods for cards.
 */
class CardUtils {
    
    /**
     Given the card's frame and the frame of the container determine the ratio of the card that is visible in the container's bounds and the ratio of the screen that is taken up by the card
     
     - Parameter containerFrame: The frame bounds of the container
     - Parameter cardFrame: The frame bounds of the card
     
     - Returns: The ratio of the card that is visible within the specified container frame
        and the ratio of the screen that is taken up by the card
     */
    class func calculateVisibilityRatios(containerFrame: CGRect, cardFrame: CGRect) -> (cardVisibilityRatio: CGFloat, containerCoverageRatio: CGFloat) {
        var visibleHeight: CGFloat = 0.0
        let cardFrameBottomY = cardFrame.origin.y + cardFrame.height
        let containerFrameBottomY = containerFrame.origin.y + containerFrame.height
        
        // if the card is cut off at the top and bottom (card is too big and takes up more than the bounds)
        if cardFrame.origin.y < containerFrame.origin.y && cardFrameBottomY > containerFrameBottomY {
            visibleHeight = containerFrame.height  // we set visible height to the height of the container (it'll always be 100% visible)
        }
        // if the top of the card is cut off by the top of the container
        else if cardFrame.origin.y < containerFrame.origin.y && cardFrameBottomY > containerFrame.origin.y {
            visibleHeight = cardFrame.height - (containerFrame.origin.y - cardFrame.origin.y)
        }
        // if the bottom of the card is cut off by the container
        else if cardFrameBottomY > containerFrameBottomY && cardFrame.origin.y < containerFrameBottomY {
            visibleHeight = containerFrame.origin.y + containerFrame.height - cardFrame.origin.y
        }
        // else the card is in full view
        else if cardFrame.origin.y >= containerFrame.origin.y && cardFrameBottomY <= containerFrameBottomY {
            visibleHeight = cardFrame.height
        }
        // not in the visible view
        else {
            return (0.0, 0.0)
        }
        
        return (visibleHeight / cardFrame.height, visibleHeight / containerFrame.height)
    }
    
    /*
     * Checks to see if the scroll of the scroll view was significant. Significance of the scroll depends on a threshold pixel value.
     *
     * @param lastScrollBounds - The rectangle of the boundary of the last scroll that occurred
     * @param currentSctollBounds - The rectangle of the boundary of the current scroll that occurred
     * @param threshold - The pixel threshold of the scroll. The scroll bounds of the last and current scroll must differ by at more than this value (>)
     */
    class func isSignificantScroll(lastScrollBounds: CGRect?, currentScrollBounds: CGRect, threshold: CGFloat) -> Bool {
        guard let bounds = lastScrollBounds else {
            return true
        }

        return abs(bounds.origin.y - currentScrollBounds.origin.y) > threshold
    }
}
