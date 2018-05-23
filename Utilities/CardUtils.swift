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
    
    /*
     * Given the card's frame and the frame of the container determine the percentage of the card that is visible in the container's bounds
     *
     * @param containerFrame - The frame bounds of the container
     * @param cardFrame - The frame bounds of the card
     *
     * @return The percentage of the card that is visible within the specified container frame
     */
    class func cardVisibility(containerFrame: CGRect, cardFrame: CGRect) -> CGFloat {
        var visibleHeight: CGFloat = 0.0
        let cardFrameBottomY = cardFrame.origin.y + cardFrame.height
        let containerFrameBottomY = containerFrame.origin.y + containerFrame.height
        
        // if the top of the card is cut off by the top of the container
        if cardFrame.origin.y < containerFrame.origin.y && cardFrameBottomY > containerFrame.origin.y {
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
            return 0.0
        }
        
        return visibleHeight / cardFrame.height
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
