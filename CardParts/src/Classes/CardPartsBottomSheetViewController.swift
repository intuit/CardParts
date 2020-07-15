//
//  CardPartsBottomSheetViewController.swift
//  CardParts
//
//  Created by Ryan Cole on 2/17/20.
//

import Foundation
import UIKit

// MARK: Bottom sheet
public class CardPartsBottomSheetViewController: UIViewController {
    
    // MARK: Public variables
    /// View controller for the content of the bottom sheet. Should set this parameter before presenting bottom sheet.
    public var contentVC: UIViewController? {
        didSet {
            DispatchQueue.main.async {
                // only update if going from non-nil to non-nil
                guard let oldValue = oldValue, self.contentVC != nil else { return }
                oldValue.removeFromParentVC()
                self.setupContent()
                // this last line will trigger updating the height
                self.contentHeight = nil
            }
        }
    }
    
    /// Manually set a content height. If not set, height will try to be inferred from the contentVC
    public var contentHeight: CGFloat? {
        didSet {
            DispatchQueue.main.async {
                self.updateHeight()
            }
        }
    }
    
    /// Background color of bottom sheet. Default is white.
    public var bottomSheetBackgroundColor: UIColor = UIColor.white
    
    /// Corner radius of bottom sheet.  Default is 16.
    public var bottomSheetCornerRadius: CGFloat = 16.0
    
    /// Pill-shaped handle at the top of the bottom sheet. Can configure its height, width, and color.
    public var handleVC: CardPartsBottomSheetHandleViewController = CardPartsBottomSheetHandleViewController()
    
    /// Positioning of handle relative to bottom sheet. Default is above with padding 8.
    public var handlePosition: BottomSheetHandlePosition = .above(bottomPadding: 8)
    
    /// Color of the background overlay. Default is black.
    public var overlayColor: UIColor = UIColor.black
    
    /// Whether or not to include a background overlay. Default is true.
    public var shouldIncludeOverlay: Bool = true
    
    /// Maximum alpha  value of background overlay. Will fade to 0 proportionally with height as bottom sheet is dragged down. Default is 0.5.
    public var overlayMaxAlpha: CGFloat = 0.5
    
    /// Ratio of how how far down user must have dragged bottom sheet before releasing it in order to trigger a dismissal. Default is 0.4.
    public var dragHeightRatioToDismiss: CGFloat = 0.4
    
    /// Velocity that must be exceeded in order to dismiss bottom sheet if height ratio is greater than `dragHeightRatioToDismiss`. Default is 250.
    public var dragVelocityToDismiss: CGFloat = 250
    
    /// Amount that the bottom sheet resists being dragged up. Default 5 means that for every 5 pixels the user drags up, the bottom sheet goes up 1 pixel.
    public var pullUpResistance: CGFloat = 5
    
    /// Animation time for bottom sheet to appear. Default is 0.5.
    public var appearAnimationDuration: TimeInterval = 0.5
    
    /// Animation time for bottom sheet to dismiss. Default is 0.5.
    public var dismissAnimationDuration: TimeInterval = 0.5
    
    /// Animation time for bottom sheet to snap back to its height. Default is 0.25.
    public var snapBackAnimationDuration: TimeInterval = 0.25
    
    /// Animation time for bottom sheet to adjust to a new height when height is changed. Default is 0.25.
    public var changeHeightAnimationDuration: TimeInterval = 0.25
    
    /// Animation options for bottom sheet animations. Default is UIView.AnimationOptions.curveEaseIn.
    public var animationOptions: UIView.AnimationOptions = .curveEaseIn
    
    /// Whether or not to dismiss if a user taps in the overlay. Default is true.
    public var shouldListenToOverlayTap: Bool = true
    
    /// Whether or not to respond to dragging on the handle. Default is true.
    public var shouldListenToHandleDrag: Bool = true
    
    /// Whether or not to respond to dragging in the content. Default is true.
    public var shouldListenToContentDrag: Bool = true
    
    /// Whether or not to respond to dragging in the container. Default is true.
    public var shouldListenToContainerDrag: Bool = true
    
    /// Whether or not to require a drag to start in the vertical direction. Default is true.
    public var shouldRequireVerticalDrag: Bool = true
    
    /// Boolean value for whether or not bottom sheet should automatically add to its height to account for bottom safe area inset. Default is true.
    public var adjustsForSafeAreaBottomInset: Bool = true
    
    /// Callback function to be called when bottom sheet is done preseting.
    public var didShow: (() -> Void)? = nil
    
    /// Callback function to be called when bottom sheet is done dismissing itself.
    /// - Parameter dismissalType: information about how the bottom sheet was dismissed
    public var didDismiss: ((_ dismissalType: BottomSheetDismissalType) -> Void)? = nil
    
    /// Callback function to be called when bottom sheet height changes from dragging or a call to `updateHeight`.
    public var didChangeHeight: ((_ newHeight: CGFloat) -> Void)? = nil
    
    /// Gesture recognizers that should block the vertical dragging of bottom sheet. Will automatically find and use all gesture recognizers if nil, otherwise will use recognizers in the array. Default is empty array.
    public var preferredGestureRecognizers: [UIGestureRecognizer]? = []
    
    // MARK: Private variables
    private var bottomSheetContainerVC: UIViewController = UIViewController()
    private var bottomSheetHeight: CGFloat = 0
    private var darkOverlay: UIView = UIView()
    private var prevTouchHeight: CGFloat = 0
    private var bottomSheetTopConstraint: NSLayoutConstraint!
    private var viewTopConstraint: NSLayoutConstraint!
    private var _contentHeight: CGFloat = 0
    private var isShowingBottomSheet: Bool = false
    
    // MARK: Public functions
    /// Adds the bottom sheet to the specified view, and makes calls to set up and display bottom sheet
    /// - Parameter view: View on which to add the bottom sheet. Defaults to key window.
    public func presentBottomSheet(on hostView: UIView? = UIApplication.shared.keyWindow) {
        guard let hostView = hostView, !isShowingBottomSheet else { return }
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        hostView.addSubview(self.view)
        
        self.view.layout {
            $0.leading == hostView.leadingAnchor
            $0.trailing == hostView.trailingAnchor
            $0.bottom == hostView.bottomAnchor
        }
        
        setup()
        
        viewTopConstraint = self.view.topAnchor.constraint(equalTo: hostView.topAnchor)
        if !shouldIncludeOverlay {
            viewTopConstraint = self.view.topAnchor.constraint(equalTo: hostView.bottomAnchor, constant: -bottomSheetHeight)
        }
        viewTopConstraint.isActive = true

        self.view.layoutIfNeeded()
        
        // animate appearing on screen
        UIView.animate(withDuration: appearAnimationDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: animationOptions, animations: {
            self.darkOverlay.alpha = self.overlayMaxAlpha
            self.bottomSheetTopConstraint.constant -= self.bottomSheetHeight
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.didShow?()
            self.isShowingBottomSheet = true
        })
    }
    
    /// Adds a shadow to the bottom sheet container with the specified properties
    public func addShadow(color: CGColor = UIColor.black.cgColor, opacity: Float = 0.2, radius: CGFloat = 4, offset: CGSize = CGSize(width: 0, height: 1)) {
        bottomSheetContainerVC.view.layer.shadowColor = color
        bottomSheetContainerVC.view.layer.shadowRadius = radius
        bottomSheetContainerVC.view.layer.shadowOffset = offset
        bottomSheetContainerVC.view.layer.shadowOpacity = opacity
    }
    
    /// Updates the private height properties and constraints, and animates the bottom sheet to new height if it is currently showing.
    public func updateHeight() {
        calculateHeight()
        
        guard isShowingBottomSheet else { return }
        // guard this because when reusing bottom sheet to avoid crash when sometimes constraints are mysteriously disappearing
        guard self.bottomSheetTopConstraint != nil, self.viewTopConstraint != nil else {
            self.dismissBottomSheet(.programmatic(info: ["error": "closing due to nil constraints"]))
            return
        }
        UIView.animate(withDuration: changeHeightAnimationDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: animationOptions, animations: {
            self.darkOverlay.alpha = self.overlayMaxAlpha
            self.bottomSheetTopConstraint.constant = -self.bottomSheetHeight
            if !self.shouldIncludeOverlay {
                self.viewTopConstraint.constant = -self.bottomSheetHeight
            }
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.didChangeHeight?(-self.bottomSheetTopConstraint.constant)
        })
    }
    
    /// Dismisses bottom sheet, calling `didDismiss` callback when complete.
    /// - Parameter dismissalType: type of dismissal
    public func dismissBottomSheet(_ dismissalType: BottomSheetDismissalType) {
        guard isShowingBottomSheet else { return }
        UIView.animate(withDuration: dismissAnimationDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: animationOptions, animations: {
            self.darkOverlay.alpha = 0
            self.bottomSheetTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.teardown()
            self.didDismiss?(dismissalType)
            self.isShowingBottomSheet = false
        })
    }
    
    // MARK: Private functions
    /// Sets up required parameters, controllers, and constraints when view loads
    private func setup() {
        calculateHeight()
        
        setupGestureRecognizers()
        
        if shouldIncludeOverlay {
            setupOverlay()
        }
        
        setupHandleAndContainer()
        
        setupContent()
    }
    
    // Calculate appropriate height.
    private func calculateHeight() {
        // if no height provided, try calculating it from the contentVC. this calculation is not always accurate, so it is recommended to pass a height
        _contentHeight = contentHeight ?? (contentVC?.height(width: self.view.frame.width) ?? 0.0)
        
        self.bottomSheetHeight = _contentHeight
        switch self.handlePosition {
        case .above(let bottomPadding):
            bottomSheetHeight += handleVC.handleHeight + bottomPadding
        default:
            break
        }
        
        // check for safe area adjustment
        if adjustsForSafeAreaBottomInset, #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomSheetHeight += window?.safeAreaInsets.bottom ?? 0
        }
    }
    
    /// Sets up dark overlay.
    private func setupOverlay() {
        
        darkOverlay.backgroundColor = overlayColor
        darkOverlay.alpha = 0
        darkOverlay.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(darkOverlay)
        
        darkOverlay.layout {
            $0.top == self.view.topAnchor
            $0.leading == self.view.leadingAnchor
            $0.trailing == self.view.trailingAnchor
            $0.bottom == self.view.bottomAnchor
        }
    }
    
    /// Sets up container and handle, adding necessary views, controllers, and constraints.
    private func setupHandleAndContainer() {
        
        bottomSheetContainerVC.view.backgroundColor = bottomSheetBackgroundColor
        bottomSheetContainerVC.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetContainerVC.view.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: bottomSheetCornerRadius)
        
        self.add(bottomSheetContainerVC)
        if handlePosition != BottomSheetHandlePosition.none {
            self.add(handleVC)
        }
        
        bottomSheetContainerVC.view.layout {
            $0.leading == self.view.leadingAnchor
            $0.trailing == self.view.trailingAnchor
        }
        
        switch handlePosition {
        case .above(let bottomPadding):
            handleVC.view.layout {
                $0.leading == self.view.leadingAnchor
                $0.trailing == self.view.trailingAnchor
                $0.bottom == self.bottomSheetContainerVC.view.topAnchor - bottomPadding
            }
        case .inside(let topPadding):
            handleVC.view.layout {
                $0.leading == self.view.leadingAnchor
                $0.trailing == self.view.trailingAnchor
                $0.top == self.bottomSheetContainerVC.view.topAnchor + topPadding
            }
        default:
            break
        }
            
        switch handlePosition {
        case .above:
            bottomSheetTopConstraint = handleVC.view.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        default:
            bottomSheetTopConstraint = bottomSheetContainerVC.view.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        
        NSLayoutConstraint.activate([
            // make container height big so we can drag it up far without seeing under it
            bottomSheetContainerVC.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 2),
            bottomSheetTopConstraint
        ])
    }
    
    /// Sets up content, adding necessary views, controllers, and constraints.
    private func setupContent() {
        
        guard let contentVC = contentVC else { return }
        bottomSheetContainerVC.add(contentVC)
        
        contentVC.view.layout {
            $0.top == self.bottomSheetContainerVC.view.topAnchor
            $0.leading == self.bottomSheetContainerVC.view.leadingAnchor
            $0.trailing == self.bottomSheetContainerVC.view.trailingAnchor
        }
    }
    
    /// Remove view controllers from parents and views from superviews and nillify constraints and remove recognizers
    private func teardown() {
        [contentVC, bottomSheetContainerVC, handleVC].forEach { $0?.removeFromParentVC() }
        [darkOverlay, self.view].forEach { $0?.removeFromSuperview() }
        viewTopConstraint = nil
        bottomSheetTopConstraint = nil
        removeGestureRecognizers()
    }
}

// MARK: Gesture Recognizers
extension CardPartsBottomSheetViewController: UIGestureRecognizerDelegate {
    /// Sets up gesture recognizers for drags and overlay tap.
    private func setupGestureRecognizers() {
        if shouldListenToContentDrag {
            let contentDragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragBottomSheet))
            contentDragGesture.delegate = self
            contentVC?.view.addGestureRecognizer(contentDragGesture)
        }
        
        if shouldListenToHandleDrag {
            let handleDragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragBottomSheet))
            handleDragGesture.delegate = self
            handleVC.view.addGestureRecognizer(handleDragGesture)
        }
        
        if shouldListenToContainerDrag {
            let containerDragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragBottomSheet))
            containerDragGesture.delegate = self
            bottomSheetContainerVC.view.addGestureRecognizer(containerDragGesture)
        }
        
        if shouldListenToOverlayTap && shouldIncludeOverlay {
            let overlayTouch = UITapGestureRecognizer(target: self, action: #selector(self.tapInOverlay))
            overlayTouch.numberOfTapsRequired = 1
            overlayTouch.numberOfTouchesRequired = 1
            darkOverlay.addGestureRecognizer(overlayTouch)
        }
    }
    
    /// Gesture recognizer for dragging bottom sheet
    @objc private func didDragBottomSheet(recognizer: UIPanGestureRecognizer) {
        // guard this because when reusing bottom sheet to avoid crash when sometimes constraints are mysteriously disappearing
        guard self.bottomSheetTopConstraint != nil else {
            dismissBottomSheet(.programmatic(info: ["error": "closing due to nil constraints"]))
            return
        }
        let touchHeight = self.view.bounds.height - recognizer.location(in: self.view).y
        let heightPercentage: CGFloat = -self.bottomSheetTopConstraint.constant / self.bottomSheetHeight
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
            self.didChangeHeight?(-self.bottomSheetTopConstraint.constant)
            darkOverlay.alpha = overlayMaxAlpha * min(heightPercentage, 1)
            prevTouchHeight = touchHeight
            self.view.layoutIfNeeded()
        case .cancelled, .ended, .failed:
            // if only gone down a little, keep it up; otherwise dismiss
            if -self.bottomSheetTopConstraint.constant > bottomSheetHeight * dragHeightRatioToDismiss && recognizer.velocity(in: self.view).y < dragVelocityToDismiss {
                UIView.animate(withDuration: snapBackAnimationDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: animationOptions, animations: {
                    self.bottomSheetTopConstraint.constant = -self.bottomSheetHeight
                    self.didChangeHeight?(-self.bottomSheetTopConstraint.constant)
                    self.darkOverlay.alpha = self.overlayMaxAlpha
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                dismissBottomSheet(.swipeDown)
            }
        default:
            break
        }
    }
    
    /// Gesture recognizer for a tap in the overlay.
    @objc private func tapInOverlay(recognizer: UITapGestureRecognizer) {
        dismissBottomSheet(.tapInOverlay)
    }
    
    /// Do not listen to our drag gestures if they conflict with gestures the user has passed as preferred (or any gesture present if `preferredGestureRecognizers == nil`).
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let contentSubviews = contentVC?.view.subviews else { return false }
        let recognizers = self.preferredGestureRecognizers ?? getAllGestureRecognizers(for: contentSubviews)
        return recognizers.contains(otherGestureRecognizer)
    }
    
    /// Only listen to drag gestures if they start out vertically unless `shouldRequireVerticalDrag` is false.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard shouldRequireVerticalDrag else { return true }
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let velocity = panGestureRecognizer.velocity(in: self.view)
        return abs(velocity.y) > abs(velocity.x)
    }
    
    /// Helper function to recursively get all the gesture recognizers from a list of views and their subviews.
    private func getAllGestureRecognizers(for subviews: [UIView]) -> [UIGestureRecognizer] {
        var recognizers = [UIGestureRecognizer]()
        for subview in subviews {
            recognizers += subview.gestureRecognizers ?? [] + getAllGestureRecognizers(for: subview.subviews)
        }
        return recognizers
    }
    
    private func removeGestureRecognizers() {
        self.darkOverlay.gestureRecognizers?.forEach { self.darkOverlay.removeGestureRecognizer($0) }
        self.handleVC.view.gestureRecognizers?.forEach { self.handleVC.view.removeGestureRecognizer($0) }
        self.contentVC?.view.gestureRecognizers?.forEach { self.contentVC?.view.removeGestureRecognizer($0) }
        self.bottomSheetContainerVC.view.gestureRecognizers?.forEach { self.bottomSheetContainerVC.view.removeGestureRecognizer($0) }
    }
}

// MARK: Convenience functions to set up properties
extension CardPartsBottomSheetViewController {
    /// Sets up bottom sheet to not listen to any user interaction, not include overlay, and not include handle
    public func configureForStickyMode() {
        self.shouldIncludeOverlay = false
        self.shouldListenToHandleDrag = false
        self.shouldListenToOverlayTap = false
        self.shouldListenToContentDrag = false
        self.shouldListenToContainerDrag = false
        self.handlePosition = .none
    }
}

// MARK: Handle view controller
public class CardPartsBottomSheetHandleViewController: UIViewController {
    /// Height of the handle. Default is 6.
    public var handleHeight : CGFloat = 6
    
    /// Width of the handle. Default is 64.
    public var handleWidth : CGFloat = 64
    
    /// Color of the handle. Default is (212, 215, 220)
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

// MARK: Enums
/// Included in didDismissCallback, can be used for analytics on user interaction with bottom sheet.
public enum BottomSheetDismissalType {
    case tapInOverlay
    case swipeDown
    case programmatic(info: [String: Any]?)
}

/// Handle position used to control positioning and padding of handle.
public enum BottomSheetHandlePosition: Equatable {
    case above(bottomPadding: CGFloat)
    case inside(topPadding: CGFloat)
    case none
}

// MARK: Protocol
/// Protocol for delegate with function to dismiss bottom sheet.
public protocol CardPartsBottomSheetDelegate: class {
    var bottomSheetViewController: CardPartsBottomSheetViewController { get set }
    func dismissBottomSheet(info: [String: Any]?)
    func updateContentHeight(to height: CGFloat?)
    func updateContentVC(to vc: UIViewController?)
    func updateHeight()
}

public extension CardPartsBottomSheetDelegate {
    func dismissBottomSheet(info: [String: Any]?) {
        bottomSheetViewController.dismissBottomSheet(.programmatic(info: info))
    }
    
    func updateContentHeight(to height: CGFloat?) {
        bottomSheetViewController.contentHeight = height
    }
    
    func updateContentVC(to contentVC: UIViewController?) {
        bottomSheetViewController.contentVC = contentVC
    }
    
    func updateHeight() {
        bottomSheetViewController.updateHeight()
    }
}
