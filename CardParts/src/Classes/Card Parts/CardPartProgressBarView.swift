//
//  CardPartProgressBarView.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 9/19/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class CardPartProgressBarView: UIView, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    public var animatable: Bool = false
    
    private var markerView: UIView!
    
    private var markerLabel: UILabel!
    
    private var valueBarsStackView: UIStackView!
    
    private var colorBarsStackView: UIStackView!
    
    private var colorBarsStackViewContainerView: UIView!
    
    private var showButtomValues: Bool = false
    
    private var totalHeight: CGFloat = 0
    
    private var progressBarOnlyHeight: CGFloat = 10
    
    private var markerHeight: CGFloat = 7
    
    private var valuesBarHeight: CGFloat = 0
    
    private var markerLabelViewHeight: CGFloat = 0
    
    fileprivate var currentVal: Double = 0
    
    
    public init(barValues:[Double], barColors: [UIColor], marker: UIView? = nil , markerLabelTitle: String? = nil, currentValue: Double, showShowBarValues: Bool) {
        
        self.barColors = barColors
        self.barValues = barValues.sorted(by: { (first, second) -> Bool in
            return first < second
        })
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let markerTitle = markerLabelTitle {
            self.markerTitle = markerTitle
        }
        
        self.currentVal = currentValue
        self.customMarker = marker
        
        if !showShowBarValues{
            valuesBarHeight = 0
        }
        
        colorBarsStackViewContainerView = UIView(frame: .zero)
        colorBarsStackViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        colorBarsStackViewContainerView.layer.opacity = 1
        colorBarsStackViewContainerView.clipsToBounds = true
        
        valueBarsStackView = UIStackView(frame: .zero)
        valueBarsStackView.axis = .horizontal
        valueBarsStackView.distribution = .fillEqually
        valueBarsStackView.translatesAutoresizingMaskIntoConstraints = false
        valueBarsStackView.spacing = 0
        valueBarsStackView.alignment = .center
        
        colorBarsStackView = UIStackView(frame: .zero)
        colorBarsStackView.axis = .horizontal
        colorBarsStackView.distribution = .fillEqually
        colorBarsStackView.translatesAutoresizingMaskIntoConstraints  = false
        colorBarsStackView.spacing = 0
        
        markerView = UIView(frame: .zero)
        markerView.contentMode = .scaleAspectFit
        markerView.sizeToFit()
        
        markerLabel = UILabel(frame: .zero)
        markerLabel.sizeToFit()
        markerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(valueBarsStackView)
        colorBarsStackViewContainerView.addSubview(colorBarsStackView)
        self.view.addSubview(colorBarsStackViewContainerView)
        self.view.addSubview(markerLabel)
        self.view.addSubview(markerView)
        addMarker(marker: marker)
        setupColorBarsStack()
        setupValueBarsStack()
        
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }
    
    public override func layoutSubviews() {
        layout()
        super.layoutSubviews()
    }
    
    private var markerTitle: String = "" {
        didSet {
            if markerTitle != "" {
                markerLabelViewHeight = markerLabelHeight ?? markerLabelViewHeight
                let titleFrame = CGRect(x: 0, y: 0, width: markerLabelViewHeight * 4, height: markerLabelViewHeight)
                markerLabel.frame = titleFrame
                markerLabel.text = markerTitle
                layout()
            } else {
                markerLabelViewHeight = 0
            }
            addMarker(marker: customMarker)
        }
    }
    
    public var markerTitleFont: UIFont = UIFont.titleTextMedium {
        didSet {
            markerLabel.font = markerTitleFont
            layout()
        }
    }
    
    public var colorsBarOffset: CGFloat = 10 {
        didSet {
            layoutSubviews()
        }
    }
    
    public var markerToColorsBarCushion: CGFloat = 4 {
        didSet(newValue){
            totalHeight -= self.markerToColorsBarCushion
            self.markerToColorsBarCushion = newValue
            totalHeight += self.markerToColorsBarCushion
            layoutSubviews()
        }
    }
    
    public var colorsBarToValuesBarCushion: CGFloat = 0 {
        didSet(newValue){
            totalHeight -= self.colorsBarToValuesBarCushion
            self.colorsBarToValuesBarCushion = newValue
            totalHeight += self.colorsBarToValuesBarCushion
            layoutSubviews()
        }
    }
    
    public var labelToMarkerCushion: CGFloat = 0 {
        didSet(newValue){
            totalHeight -= self.labelToMarkerCushion
            self.labelToMarkerCushion = newValue
            totalHeight += self.labelToMarkerCushion
            layoutSubviews()
        }
    }
    
    private var customMarker: UIView? {
        didSet {
            addMarker(marker: customMarker)
            layoutSubviews()
        }
    }
    
    public var bgColor: UIColor = UIColor.white {
        didSet {
            addMarker(marker: customMarker)
            layoutSubviews()
        }
    }
    
    public var markerColor: UIColor? = UIColor.Black {
        didSet {
            if markerColor != nil {
                layout()
            }
        }
    }
    
    private var barColors: [UIColor] = [] {
        didSet {
            assert(barColors.count > 0, "Requirement: barColors >=1")
            if !barColors.isEmpty {
                setupColorBarsStack()
                layout()
            }
        }
    }
    
    private var barValues: [Double] = [] {
        didSet {
            assert(barValues.count > 1, "Requirement: barValues >=2")
            if !barValues.isEmpty {
                assert(self.barValues.count == self.barColors.count + 1, "Requirement: barValues = barColors + 1 ")
                setupValueBarsStack()
                layoutSubviews()
            } else {
                layoutSubviews()
                valuesBarHeight = 0
            }
        }
    }
    
    public var barCornerRadius: CGFloat? {
        didSet {
            layoutIfNeeded()
        }
    }
    
    public var viewCornerRadius: CGFloat? {
        didSet {
            if  viewCornerRadius != nil {
                layoutIfNeeded()
            }
        }
    }
    
    public var barHeight: CGFloat? {
        didSet {
            if let height = barHeight {
                totalHeight -= self.progressBarOnlyHeight
                self.progressBarOnlyHeight = height
                totalHeight += self.progressBarOnlyHeight
                layoutIfNeeded()
            }
        }
    }
    
    public var buttomValuesContainerHeight: CGFloat? {
        didSet {
            if let height = buttomValuesContainerHeight {
                totalHeight -= self.valuesBarHeight
                self.valuesBarHeight = height
                totalHeight += self.progressBarOnlyHeight
                layoutIfNeeded()
            }
        }
    }
    
    public var markerViewHeight: CGFloat?  {
        didSet {
            if let height = markerViewHeight {
                totalHeight -= self.markerHeight
                self.valuesBarHeight = height
                totalHeight += self.markerHeight
                layoutIfNeeded()
            }
        }
    }
    
    public var markerLabelHeight: CGFloat?  {
        didSet {
            if let height = markerLabelHeight {
                totalHeight -= self.markerLabelViewHeight
                self.markerLabelViewHeight = height
                totalHeight += self.markerLabelViewHeight
                layoutIfNeeded()
            }
        }
    }
    
    public override func updateConstraints() {
        NSLayoutConstraint.activate([
            self.markerView.bottomAnchor.constraint(equalTo: self.colorBarsStackView.topAnchor, constant: -self.markerToColorsBarCushion),
            self.markerView.widthAnchor.constraint(equalTo: self.markerView.heightAnchor, multiplier: 1.0, constant: 0),
            self.markerView.centerXAnchor.constraint(equalTo: colorBarsStackView.leadingAnchor),

            self.markerLabel.bottomAnchor.constraint(equalTo: self.markerView.topAnchor, constant: -self.labelToMarkerCushion),

            self.colorBarsStackView.bottomAnchor.constraint(equalTo: self.valueBarsStackView.topAnchor),
            self.colorBarsStackViewContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.colorsBarOffset),
            self.colorBarsStackViewContainerView.heightAnchor.constraint(equalToConstant: self.progressBarOnlyHeight),
            self.colorBarsStackViewContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.colorsBarOffset),
            self.colorBarsStackViewContainerView.bottomAnchor.constraint(equalTo: self.valueBarsStackView.topAnchor, constant: -self.colorsBarToValuesBarCushion),
            
            self.colorBarsStackView.trailingAnchor.constraint(equalTo: self.colorBarsStackViewContainerView.trailingAnchor),
            //self.colorBarsStackView.leadingAnchor.constraint(equalTo: self.colorBarsStackViewContainerView.leadingAnchor),
            self.colorBarsStackView.topAnchor.constraint(equalTo: self.colorBarsStackViewContainerView.topAnchor),
            self.colorBarsStackView.bottomAnchor.constraint(equalTo: self.colorBarsStackViewContainerView.bottomAnchor),

            self.valueBarsStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.valueBarsStackView.heightAnchor.constraint(equalToConstant: self.valuesBarHeight),
            self.valueBarsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.valueBarsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        ])
        
        let viewContraints = [
            NSLayoutConstraint(item: colorBarsStackView as Any, attribute: .leading, relatedBy: .equal, toItem: colorBarsStackViewContainerView, attribute: .leading, multiplier: 1, constant: 0)
        ]

        self.addConstraints(viewContraints)
        super.updateConstraints()
    }
    
    private func layout() {
        
        updateConstraints()
        
        if let barRadius = barCornerRadius {
            colorBarsStackView.clipsToBounds = true
            colorBarsStackViewContainerView.layer.cornerRadius = barRadius
        }
        
        let markerFrame = CGRect(x: self.colorBarsStackView.frame.origin.x, y: 0, width: markerHeight + 3, height: markerHeight)
        markerView.frame = markerFrame
        
        let markerLabelFrame = CGRect(x: 0, y: 0, width: 40, height: self.markerLabelViewHeight)
        markerLabel.frame = markerLabelFrame
        markerLabel.text = markerTitle
        markerLabel.sizeToFit()
        
        let viewHeight: CGFloat = valueBarsStackView.frame.height + colorBarsStackView.frame.height + markerView.frame.height + markerLabel.frame.height + markerToColorsBarCushion + colorsBarToValuesBarCushion + labelToMarkerCushion
        
        let mainFrame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: viewHeight)
        self.view.frame = mainFrame
        self.frame = mainFrame
        
        if barValues.count > 1, barColors.count > 0, barValues.count == barColors.count + 1 {
            animateBasedOnCurrentValue(currentVal)
        }
        
        updateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func addMarker(marker: UIView?) {
        let color: UIColor = UIColor.black
        
        if let marker = marker {
            self.markerView.addSubview(marker)
        } else {
            let triangleView = CardPartTriangleView(frame: CGRect(x: 0, y: 0, width: markerHeight, height: markerHeight))
            triangleView.fillColor = color
            triangleView.backgroundColor = .white
            self.markerView.addSubview(triangleView)
        }
        layoutSubviews()
    }
    
    fileprivate func setupColorBarsStack(){
        for color in barColors {
            let count = barColors.count
            let width = (colorBarsStackView.frame.width)/CGFloat(count)
            let height = colorBarsStackView.frame.height
            let colorView = UIView()
            colorView.layer.masksToBounds = true
            colorView.backgroundColor = color
            colorView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            colorBarsStackView.addArrangedSubview(colorView)
        }
        layoutSubviews()
    }
    
    fileprivate func setupValueBarsStack(){
        guard barValues.count != 0 && showButtomValues else {return}
        for value in barValues {
            let count = barValues.count
            let width = valueBarsStackView.frame.width/CGFloat(count)
            let height = valueBarsStackView.frame.height
            let valueLabel = UILabel()
            valueLabel.frame = CGRect(x: 0, y: 0, width: width, height: height)
            valueLabel.text = "\(value)"
            valueLabel.textAlignment = .center
            valueBarsStackView.addArrangedSubview(valueLabel)
        }
        layoutSubviews()
    }
    
    private func animateBasedOnCurrentValue(_ value: Double) {
        if value <= barValues[0] {
            // MARK: - Case 1: current value is less than the smallest value
            animateProgressBar(0)
            return
        }
        
        if let lastBarValue = barValues.last,
            // MARK: - Case 2: current value is greater or equal than greatest value
            value >= lastBarValue {
            
            markerLabel.centerXAnchor.constraint(equalTo: markerView.centerXAnchor)
            let trailingMarkerAndLabelConstraint = self.markerView.trailingAnchor.constraint(equalTo: self.markerLabel.trailingAnchor)
            trailingMarkerAndLabelConstraint.priority = .required
            animateProgressBar(1.0)
            return
        }
        
        // MARK: - Case 3: current value falls within the range
        for segment in 0..<barValues.count - 1 {
            let start = barValues[segment]
            let end = barValues[segment+1]
            let centerConstraint = self.markerLabel.centerXAnchor.constraint(equalTo: self.markerView.centerXAnchor)
            centerConstraint.priority = .required
            
            if value >= start && value < end {
                animateMarkerWithinRange(from: start, to: end, currentValue: value, offset: Double(segment))
                break
            }
        }
    }
    
    private func animateMarkerWithinRange(from bottomRange: Double, to topRange: Double, currentValue: Double, offset: Double) {
        
        let range = topRange - bottomRange
        let currentRange = currentValue - bottomRange
        let currentRatio = currentRange / range
        
        let finalPercent = currentRatio/Double(barColors.count) + (offset*0.2)
        animateProgressBar(finalPercent)
    }
    
    private func animateProgressBar(_ percentOfBar: Double) {
        updateConstraints()
        let change = (self.colorBarsStackView.frame.width * CGFloat(percentOfBar) + (self.markerView.frame.size.width/(3/2)))
        if animatable {
            UIView.animate(withDuration: 1, animations: {
                self.markerView.center.x += change
                self.view.layoutIfNeeded()
            })
        } else {
            self.markerView.center.x += change
            self.view.layoutIfNeeded()
        }
    }
}

extension Reactive where Base: CardPartProgressBarView {
    
    public var currentValue: Binder<Double> {
        return Binder(self.base) { (progressBarView, value) -> () in
            progressBarView.currentVal = value
        }
    }
    
    public var bgColor: Binder<UIColor> {
        return Binder(self.base) { (view, color) -> () in
            view.bgColor = color
        }
    }
    
    public var barCornerRadius: Binder<CGFloat> {
        return Binder(self.base) { (view, radius) -> () in
            view.barCornerRadius = radius
        }
    }
    
    public var markerColor: Binder<UIColor> {
        return Binder(self.base) { (view, markerColor) -> () in
            view.markerColor = markerColor
        }
    }
}

