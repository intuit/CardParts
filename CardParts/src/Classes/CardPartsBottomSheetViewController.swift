//
//  CardPartsBottomSheetViewController.swift
//  CardParts
//
//  Created by Ryan Cole on 2/17/20.
//

import Foundation
import UIKit

public class CardPartsBottomSheetViewController: UIViewController {
    
    public var contentVC: UIViewController?
    public var contentHeight: CGFloat?
    public var bottomSheetContainerVC: UIViewController = UIViewController()
    public var bottomSheetBackgroundColor: UIColor = UIColor.white
    public var bottomSheetCornerRadius: CGFloat = 16.0
    public var handleVC: CardPartsBottomSheetHandleViewController = CardPartsBottomSheetHandleViewController()
    public var overlayColor: UIColor = UIColor.black
    public var overlayMaxAlpha: CGFloat = 0.5
    public var handleBottomPadding: CGFloat = 8.0
    public var dragHeightRatioToDismiss: CGFloat = 0.4
    public var dragVelocityToDismiss: CGFloat = 250
    public var pullUpResistance: CGFloat = 5
    public var appearAnimationDuration: TimeInterval = 0.5
    public var dismissAnimationDuration: TimeInterval = 0.5
    public var snapBackAnimationDuration: TimeInterval = 0.25
    public var adjustsForSafeAreaBottomInset: Bool = true
    
    private var bottomSheetHeight: CGFloat = 0
    private var darkOverlay: UIView = UIView()
    private var prevTouchHeight: CGFloat = 0
    private var bottomSheetTopConstraint: NSLayoutConstraint!
        
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // if no height provided, try calculating it from the contentVC. this calculation is not always accurate, so it is recommended to pass a height
        let height: CGFloat = contentHeight ?? (contentVC?.height(width: self.view.frame.width) ?? 0.0)
        
        self.bottomSheetHeight = height + handleVC.handleHeight + handleBottomPadding
        
        darkOverlay.backgroundColor = overlayColor
        darkOverlay.alpha = 0
        darkOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        bottomSheetContainerVC.view.backgroundColor = bottomSheetBackgroundColor
        bottomSheetContainerVC.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetContainerVC.view.roundedTop(radius: bottomSheetCornerRadius)
        
        // check for safe area adjustment
        if adjustsForSafeAreaBottomInset, #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomSheetHeight += window?.safeAreaInsets.bottom ?? 0
        }
        
        setupGestureRecognizers()
        
        setupOverlayView()
        setupContentView()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: appearAnimationDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.darkOverlay.alpha = self.overlayMaxAlpha
            self.bottomSheetTopConstraint.constant -= self.bottomSheetHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func presentBottomSheet(on view: UIView? = UIApplication.shared.keyWindow) {
        guard let view = view else { return }
        
        view.addSubview(self.view)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: view.topAnchor),
            self.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupGestureRecognizers() {
        let contentDragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragBottomSheet))
        contentVC?.view.addGestureRecognizer(contentDragGesture)
        
        let handleDragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragBottomSheet))
        handleVC.view.addGestureRecognizer(handleDragGesture)
        
        let containerDragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragBottomSheet))
        bottomSheetContainerVC.view.addGestureRecognizer(containerDragGesture)
        
        let overlayTouch = UITapGestureRecognizer(target: self, action: #selector(self.tapInOverlay))
        overlayTouch.numberOfTapsRequired = 1
        overlayTouch.numberOfTouchesRequired = 1
        darkOverlay.addGestureRecognizer(overlayTouch)
    }
    
    func setupOverlayView() {

        self.view.addSubview(darkOverlay)
        
        darkOverlay.layout {
            $0.top == self.view.topAnchor
            $0.leading == self.view.leadingAnchor
            $0.trailing == self.view.trailingAnchor
            $0.bottom == self.view.bottomAnchor
        }
    }
    
    func setupContentView() {
        
        guard let contentVC = contentVC else { return }
        bottomSheetContainerVC.add(contentVC)
        
        contentVC.view.layout {
            $0.top == self.bottomSheetContainerVC.view.topAnchor
            $0.leading == self.bottomSheetContainerVC.view.leadingAnchor
            $0.trailing == self.bottomSheetContainerVC.view.trailingAnchor
        }
        
        [bottomSheetContainerVC, handleVC].forEach { (viewController) in
            self.add(viewController)
        }
        
        bottomSheetContainerVC.view.layout {
            $0.leading == self.view.leadingAnchor
            $0.trailing == self.view.trailingAnchor
        }
        
        handleVC.view.layout {
            $0.leading == self.view.leadingAnchor
            $0.trailing == self.view.trailingAnchor
            $0.bottom == self.bottomSheetContainerVC.view.topAnchor - self.handleBottomPadding
        }
                
        bottomSheetTopConstraint = handleVC.view.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            contentVC.view.heightAnchor.constraint(equalToConstant: bottomSheetHeight - handleVC.handleHeight - handleBottomPadding),
            bottomSheetContainerVC.view.heightAnchor.constraint(equalToConstant: self.view.frame.height * 2),
            bottomSheetTopConstraint
        ])
        
        
        
        self.view.layoutIfNeeded()
        
    }
    
    @objc func didDragBottomSheet(recognizer: UIPanGestureRecognizer) {
        let touchHeight = self.view.bounds.height - recognizer.location(in: self.view).y
        let heightPercentage = -self.bottomSheetTopConstraint.constant / self.bottomSheetHeight
        switch recognizer.state {
        case .began:
            prevTouchHeight = touchHeight
        case .changed:
            let heightChange = prevTouchHeight - touchHeight
            
            // allow dragging up but make it harder
            if self.bottomSheetTopConstraint.constant >= -bottomSheetHeight - heightChange {
                self.bottomSheetTopConstraint.constant += heightChange
            } else {
                self.bottomSheetTopConstraint.constant += (heightChange / pullUpResistance)
            }
            darkOverlay.alpha = overlayMaxAlpha * min(heightPercentage, 1)
            prevTouchHeight = touchHeight
            self.view.layoutIfNeeded()
        case .cancelled, .ended, .failed:
            // if only gone down a little, keep it up; otherwise dismiss
            if -self.bottomSheetTopConstraint.constant > bottomSheetHeight * dragHeightRatioToDismiss && recognizer.velocity(in: self.view).y < dragVelocityToDismiss {
                UIView.animate(withDuration: snapBackAnimationDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.bottomSheetTopConstraint.constant = -self.bottomSheetHeight
                    self.darkOverlay.alpha = self.overlayMaxAlpha
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                dismissModal()
            }
        default:
            break
        }
    }
    
    @objc func tapInOverlay(recognizer: UITapGestureRecognizer) {
        dismissModal()
    }
    
    func dismissModal() {
        UIView.animate(withDuration: dismissAnimationDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.darkOverlay.alpha = 0
            self.bottomSheetTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.view.removeFromSuperview()
        })
    }
    
    func changeHeight(contentHeight: CGFloat) {
        self.bottomSheetHeight = contentHeight + handleVC.handleHeight + handleBottomPadding
        
        UIView.animate(withDuration: appearAnimationDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.darkOverlay.alpha = self.overlayMaxAlpha
            self.bottomSheetTopConstraint.constant = -self.bottomSheetHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

public class CardPartsBottomSheetHandleViewController: UIViewController {
    
    public var handleHeight : CGFloat = 6
    public var handleWidth : CGFloat = 64
    public var handleColor : UIColor = UIColor.color(212, green: 215, blue: 220)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let handleView = UIView()
        handleView.backgroundColor = self.handleColor
        handleView.translatesAutoresizingMaskIntoConstraints = false
        handleView.layer.cornerRadius = self.handleHeight / 2
        
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(handleView)
        
        handleView.layout {
            $0.centerX == self.view.centerXAnchor
            $0.centerY == self.view.centerYAnchor
        }
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: self.handleHeight),
            handleView.heightAnchor.constraint(equalToConstant: self.handleHeight),
            handleView.widthAnchor.constraint(equalToConstant: self.handleWidth)
        ])
    }
    
}
