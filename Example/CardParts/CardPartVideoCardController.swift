//
//  CardPartVideoCardController.swift
//  CardParts_Example
//
//  Created by Venkatnarayansetty, Badarinath on 10/26/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CardParts
import AVKit

class CardPartVideoCardController: CardPartsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoUrl = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")  else  { return }
        
        let cardPartVideoView = CardPartVideoView(videoUrl: videoUrl)
        
        let controller = cardPartVideoView.viewController as! AVPlayerViewController
        controller.delegate = self
        if #available(iOS 11.0, *) {
            controller.entersFullScreenWhenPlaybackBegins = true
        }
        
        setupCardParts([cardPartVideoView])
    }
}

extension CardPartVideoCardController: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("video going full screen")
    }
}

