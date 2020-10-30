//
//  CardPartVideoConttollerView.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 10/26/20.
//

import Foundation
import AVFoundation
import AVKit

public class CardPartVideoView: UIView, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    // url of the video to load on the AVPlayer
    public var videoUrl:URL
    
    // player instance
    fileprivate var player: AVPlayer!
    
    fileprivate let controller = AVPlayerViewController()
    
    public var viewController: UIViewController? {
        get {
            return controller
        }
    }
    
    // convenience initilazer for setting up the videp player
    public init(videoUrl: URL) {
        self.videoUrl = videoUrl
        super.init(frame: .zero)
        setupVideoPlayer()
        setupConstraints()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // The height of the CardPartVideoView. Default is 300 points. Override this to set a custom height.
    open var playerHeight: CGFloat = 300 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    // sets up player by configuring teh view and adding it to the subview
    func setupVideoPlayer() {
        player = AVPlayer(url: videoUrl)
        controller.player = player
        controller.view.frame = self.view.frame
        addSubview(controller.view)
    }
    
    // update the height constraints for the player
    public override func updateConstraints() {
        if let heightConstraint = constraints.first(where: { $0.identifier == "CPVHeight" }) {
            heightConstraint.constant = self.playerHeight
        }
        super.updateConstraints()
    }
    
    // Setup the initial constraints
    private func setupConstraints() {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: playerHeight)
        heightConstraint.identifier = "CPVHeight"
        self.addConstraint(heightConstraint)
    }
}
