//
//  CardPartBottomSheetCardController.swift
//  CardParts_Example
//
//  Created by Ryan Cole on 2/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CardParts
import RxSwift

class CardPartBottomSheetCardController: CardPartsViewController, CardPartsBottomSheetDelegate {
    lazy var cardPartButtonView: CardPartButtonView = {
        let button = CardPartButtonView()
        button.setTitle("Tap to show bottom sheet", for: .normal)
        return button
    }()
    
    lazy var cardPartButtonViewForSticky: CardPartButtonView = {
        let button = CardPartButtonView()
        button.setTitle("Tap to show ~sticky~ bottom sheet", for: .normal)
        button.setTitleColor(.brown, for: .normal)
        return button
    }()
    
    lazy var cardPartButtonViewForInternalHandle: CardPartButtonView = {
        let button = CardPartButtonView()
        button.setTitle("Tap to show one with internal handle", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        return button
    }()
    
    lazy var bottomSheetViewControllerWithOverlay: CardPartsBottomSheetViewController = {
        let bottomSheet = CardPartsBottomSheetViewController()
        return bottomSheet
    }()
    
    lazy var bottomSheetViewControllerNoOverlay: CardPartsBottomSheetViewController = {
        let bottomSheet = CardPartsBottomSheetViewController()
        bottomSheet.configureForStickyMode()
        bottomSheet.bottomSheetCornerRadius = 8.0
        bottomSheet.addShadow(color: UIColor.black.cgColor, opacity: 0.16, radius: 8.0, offset: CGSize(width: 0, height: 2))
        bottomSheet.contentHeight = 175
        return bottomSheet
    }()
    
    lazy var bottomSheetViewControllerInternalHandle: CardPartsBottomSheetViewController = {
        let bottomSheet = CardPartsBottomSheetViewController()
        bottomSheet.handlePosition = .inside(topPadding: 8)
        bottomSheet.handleVC.handleWidth = 32
        bottomSheet.bottomSheetBackgroundColor = .yellow
        bottomSheet.overlayColor = .purple
        bottomSheet.overlayMaxAlpha = 0.25
        bottomSheet.dragHeightRatioToDismiss = 0.2
        bottomSheet.dragVelocityToDismiss = 8000
        bottomSheet.pullUpResistance = 2
        bottomSheet.shouldRequireVerticalDrag = false
        bottomSheet.didDismiss = sheetDidDismiss(_:)
        bottomSheet.didShow = sheetDidShow
        bottomSheet.didChangeHeight = sheetDidChangeHeight(_:)
        return bottomSheet
    }()
    
    func sheetDidDismiss(_ dismissalType: BottomSheetDismissalType) {
        print("bottom sheet dismissed with type \(dismissalType)")
    }
    
    func sheetDidShow() {
        print("bottom sheet appeared")
    }
    
    func sheetDidChangeHeight(_ newHeight: CGFloat) {
        print("bottom sheet changed height to \(newHeight)")
    }
    
    lazy var bottomSheetViewController: CardPartsBottomSheetViewController = self.bottomSheetViewControllerWithOverlay
    let bottomSheetContentVC = BottomSheetContentViewController()
    let stickyContentVC = StickyContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartButtonView.rx.tap.bind {
            self.bottomSheetViewController = self.bottomSheetViewControllerWithOverlay
            self.bottomSheetContentVC.bottomSheetDelegate = self
            self.bottomSheetViewController.contentVC = self.bottomSheetContentVC
            self.bottomSheetViewController.presentBottomSheet()
        }.disposed(by: bag)
        
        cardPartButtonViewForSticky.rx.tap.bind {
            self.bottomSheetViewControllerNoOverlay.contentHeight = 140
            self.bottomSheetViewController = self.bottomSheetViewControllerNoOverlay
            self.stickyContentVC.bottomSheetDelegate = self
            self.bottomSheetViewControllerNoOverlay.contentVC = self.stickyContentVC
            self.bottomSheetViewControllerNoOverlay.presentBottomSheet(on: self.parent!.view)
        }.disposed(by: bag)
        
        cardPartButtonViewForInternalHandle.rx.tap.bind {
            self.bottomSheetViewController = self.bottomSheetViewControllerInternalHandle
            self.bottomSheetContentVC.bottomSheetDelegate = self
            self.bottomSheetViewControllerInternalHandle.contentVC = self.bottomSheetContentVC
            self.bottomSheetViewControllerInternalHandle.presentBottomSheet()
        }.disposed(by: bag)
        
        setupCardParts([cardPartButtonView, cardPartButtonViewForSticky, cardPartButtonViewForInternalHandle])
    }
}

class BottomSheetContentViewController: CardPartsViewController {
    lazy var increaseHeightButton: CardPartButtonView = {
        let increaseHeightButton = CardPartButtonView()
        increaseHeightButton.setTitle("set height to 400", for: .normal)
        increaseHeightButton.rx.tap.bind {
            self.bottomSheetDelegate?.updateContentHeight(to: 400)
        }.disposed(by: bag)
        return increaseHeightButton
    }()
    
    lazy var decreaseHeightButton: CardPartButtonView = {
        let decreaseHeightButton = CardPartButtonView()
        decreaseHeightButton.setTitle("reset height", for: .normal)
        decreaseHeightButton.rx.tap.bind {
            self.bottomSheetDelegate?.updateContentHeight(to: nil)
        }.disposed(by: bag)
        return decreaseHeightButton
    }()
    
    lazy var changeVcButton: CardPartButtonView = {
        let changeVcButton = CardPartButtonView()
        changeVcButton.setTitle("change to smaller VC", for: .normal)
        changeVcButton.rx.tap.bind {
            self.bottomSheetDelegate?.updateContentVC(to: self.contentVCTwo)
        }.disposed(by: bag)
        return changeVcButton
    }()
    
    lazy var contentVCTwo: BottomSheetContentViewControllerTwo = {
        let vc2 = BottomSheetContentViewControllerTwo()
        vc2.bottomSheetDelegate = self.bottomSheetDelegate
        return vc2
    }()
    
    lazy var cardPartTextView: CardPartTextView = {
        let text = CardPartTextView(type: .normal)
        text.text = "Bottom sheet!"
        text.font = UIFont.systemFont(ofSize: 30)
        return text
    }()
    
    lazy var multiSlider: CardPartMultiSliderView = {
        let cardPartMultiSliderView = CardPartMultiSliderView()
        cardPartMultiSliderView.minimumValue = 0
        cardPartMultiSliderView.maximumValue = 100
        cardPartMultiSliderView.value = [25, 75]
        cardPartMultiSliderView.orientation = .horizontal
        cardPartMultiSliderView.trackWidth = 8
        cardPartMultiSliderView.outerTrackColor = .gray
        cardPartMultiSliderView.tintColor = .blue
        return cardPartMultiSliderView
    }()
    
    weak var bottomSheetDelegate: CardPartsBottomSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCardParts([increaseHeightButton, decreaseHeightButton, changeVcButton, cardPartTextView, multiSlider])
    }
}

class BottomSheetContentViewControllerTwo: CardPartsViewController {
    lazy var dismissButton: CardPartButtonView = {
        let dismissButton = CardPartButtonView()
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.rx.tap.bind {
            self.bottomSheetDelegate?.dismissBottomSheet(info: nil)
        }.disposed(by: bag)
        return dismissButton
    }()
    
    lazy var changeVcButton: CardPartButtonView = {
        let changeVcButton = CardPartButtonView()
        changeVcButton.setTitle("change vc back", for: .normal)
        changeVcButton.rx.tap.bind {
            self.bottomSheetDelegate?.updateContentVC(to: self.contentVCOne)
        }.disposed(by: bag)
        return changeVcButton
    }()
    
    lazy var contentVCOne: BottomSheetContentViewController = {
        let vc1 = BottomSheetContentViewController()
        vc1.bottomSheetDelegate = self.bottomSheetDelegate
        return vc1
    }()
    
    lazy var cardPartTextView: CardPartTextView = {
        let text = CardPartTextView(type: .normal)
        text.text = "small bottom sheet"
        text.font = UIFont.systemFont(ofSize: 16)
        return text
    }()
    
    weak var bottomSheetDelegate: CardPartsBottomSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCardParts([dismissButton, changeVcButton, cardPartTextView])
    }
}

class StickyContentViewController: CardPartsViewController {
    
    lazy var cardPartTextView: CardPartTextView = {
        let text = CardPartTextView(type: .normal)
        text.text = "sticky bottom sheet"
        text.font = UIFont.systemFont(ofSize: 24)
        return text
    }()
    
    lazy var dismissButton: CardPartButtonView = {
        let dismissButton = CardPartButtonView()
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.rx.tap.bind {
            self.bottomSheetDelegate?.dismissBottomSheet(info: nil)
        }.disposed(by: bag)
        return dismissButton
    }()
    
    weak var bottomSheetDelegate: CardPartsBottomSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCardParts([cardPartTextView, dismissButton])
    }
}

