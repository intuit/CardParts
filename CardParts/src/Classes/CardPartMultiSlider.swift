//
//  CardPartMultiSlider.swift
//  UISlider clone with multiple thumbs and values, and optional snap intervals.
//
//  Created by Brian Carreon on 14.11.2016.
//  Copyright © 2016 Brian Carreon. All rights reserved.
//

import UIKit

open class CardPartMultiSlider: UIControl {
    open var value: [CGFloat] = [] {
        didSet {
            if isSettingValue { return }
            adjustThumbCountToValueCount()
            adjustValuesToStepAndLimits()
            updateAllValueLabels()
            accessibilityValue = value.description
        }
    }

    public internal(set) var draggedThumbIndex: Int = -1

    open dynamic var minimumValue: CGFloat = 0 { didSet { adjustValuesToStepAndLimits() } }
    open dynamic var maximumValue: CGFloat = 1 { didSet { adjustValuesToStepAndLimits() } }
    open dynamic var isContinuous: Bool = true

    /// snap thumbs to specific values, evenly spaced. (default = 0: allow any value)
    open dynamic var snapStepSize: CGFloat = 0 { didSet { adjustValuesToStepAndLimits() } }

    /// generate haptic feedback when hitting snap steps
    open dynamic var isHapticSnap: Bool = true

    open dynamic var thumbCount: Int {
        get {
            return thumbViews.count
        }
        set {
            guard newValue > 0 else { return }
            updateValueCount(newValue)
            adjustThumbCountToValueCount()
        }
    }

    /// make specific thumbs fixed (and grayed)
    open var disabledThumbIndices: Set<Int> = [] {
        didSet {
            for i in 0 ..< thumbCount {
                thumbViews[i].blur(disabledThumbIndices.contains(i))
            }
        }
    }

    /// show value labels next to thumbs. (default: show no label)
    open dynamic var valueLabelPosition: NSLayoutConstraint.Attribute = .notAnAttribute {
        didSet {
            valueLabels.removeViewsStartingAt(0)
            if valueLabelPosition != .notAnAttribute {
                for i in 0 ..< thumbViews.count {
                    addValueLabel(i)
                }
            }
        }
    }

    /// value label shows difference from previous thumb value (true) or absolute value (false = default)
    open dynamic var isValueLabelRelative: Bool = false {
        didSet {
            updateAllValueLabels()
        }
    }

    // MARK: - Appearance

    open dynamic var isVertical: Bool {
        get { return orientation == .vertical }
        set { orientation = newValue ? .vertical : .horizontal }
    }

    open dynamic var orientation: NSLayoutConstraint.Axis = .vertical {
        didSet {
            let oldConstraintAttribute: NSLayoutConstraint.Attribute = oldValue == .vertical ? .width : .height
            removeFirstConstraint(where: { $0.firstAttribute == oldConstraintAttribute && $0.firstItem === self && $0.secondItem == nil })
            setupOrientation()
            invalidateIntrinsicContentSize()
            repositionThumbViews()
        }
    }

    /// track color before first thumb and after last thumb. `nil` means to use the tintColor, like the rest of the track.
    open dynamic var outerTrackColor: UIColor? {
        didSet {
            updateOuterTrackViews()
        }
    }

    open dynamic var thumbImage: UIImage? {
        didSet {
            thumbViews.forEach { $0.image = thumbImage }
            setupTrackLayoutMargins()
            invalidateIntrinsicContentSize()
        }
    }

    public dynamic var showsThumbImageShadow: Bool = true {
        didSet {
            updateThumbViewShadowVisibility()
        }
    }

    open dynamic var minimumImage: UIImage? {
        get {
            return minimumView.image
        }
        set {
            minimumView.image = newValue
            minimumView.isHidden = newValue == nil
            layoutTrackEdge(
                toView: minimumView,
                edge: .bottom(in: orientation),
                superviewEdge: orientation == .vertical ? .bottomMargin : .leadingMargin
            )
        }
    }

    open dynamic var maximumImage: UIImage? {
        get {
            return maximumView.image
        }
        set {
            maximumView.image = newValue
            maximumView.isHidden = newValue == nil
            layoutTrackEdge(
                toView: maximumView,
                edge: .top(in: orientation),
                superviewEdge: orientation == .vertical ? .topMargin : .trailingMargin
            )
        }
    }

    open dynamic var trackWidth: CGFloat = 2 {
        didSet {
            let widthAttribute: NSLayoutConstraint.Attribute = orientation == .vertical ? .width : .height
            trackView.removeFirstConstraint { $0.firstAttribute == widthAttribute }
            trackView.constrain(widthAttribute, to: trackWidth)
            updateTrackViewCornerRounding()
        }
    }

    public dynamic var hasRoundTrackEnds: Bool = true {
        didSet {
            updateTrackViewCornerRounding()
        }
    }

    public dynamic var keepsDistanceBetweenThumbs: Bool = true

    open dynamic var valueLabelFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.roundingMode = .halfEven
        return formatter
    }() {
        didSet {
            updateAllValueLabels()
            if #available(iOS 11.0, *) {
                oldValue.removeObserverForAllProperties(observer: self)
                valueLabelFormatter.addObserverForAllProperties(observer: self)
            }
        }
    }

    // MARK: - Subviews

    open var thumbViews: [UIImageView] = []
    open var valueLabels: [UITextField] = [] // UILabels are a pain to layout, text fields look nice as-is.
    open var trackView = UIView()
    open var outerTrackViews: [UIView] = []
    open var minimumView = UIImageView()
    open var maximumView = UIImageView()

    // MARK: - Internals

    let slideView = UIView()
    let panGestureView = UIView()
    let margin: CGFloat = 32
    var isSettingValue = false
    lazy var defaultThumbImage: UIImage? = .circle()

    // MARK: - Overrides

    open override func tintColorDidChange() {
        let thumbTint = thumbViews.map { $0.tintColor } // different thumbs may have different tints
        super.tintColorDidChange()
        trackView.backgroundColor = actualTintColor
        for (thumbView, tint) in zip(thumbViews, thumbTint) {
            thumbView.tintColor = tint
        }
    }

    open override var intrinsicContentSize: CGSize {
        let thumbSize = (thumbImage ?? defaultThumbImage)?.size ?? CGSize(width: margin, height: margin)
        switch orientation {
        case .vertical:
            return CGSize(width: thumbSize.width + margin, height: UIView.noIntrinsicMetric)
        default:
            return CGSize(width: UIView.noIntrinsicMetric, height: thumbSize.height + margin)
        }
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden || alpha == 0 { return nil }
        if clipsToBounds { return super.hitTest(point, with: event) }
        return panGestureView.hitTest(panGestureView.convert(point, from: self), with: event)
    }

    // swiftlint:disable:next block_based_kvo
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NumberFormatter === valueLabelFormatter {
            updateAllValueLabels()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    deinit {
        valueLabelFormatter.removeObserverForAllProperties(observer: self)
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        // make visual editing easier
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor

        // evenly distribute thumbs
        let oldThumbCount = thumbCount
        thumbCount = 0
        thumbCount = oldThumbCount
    }
}
