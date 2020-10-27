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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        guard let cdnUrl = URL(string: "https://offcnt.intuit.com/videos/US/Jerry/09.30.20_Anna_Reed_Testimonial_1920x1080.mp4")  else  { return }

        let player = AVPlayer(url: cdnUrl)
        let controller = AVPlayerViewController()
        controller.player = player
//        controller.view.frame = CGRect(x: 40, y: 200, width: 350, height: 280)
//        self.view.addSubview(controller.view)
//        self.addChild(controller)
//        player.play()
    }
}
