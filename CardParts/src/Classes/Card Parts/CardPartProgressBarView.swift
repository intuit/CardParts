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
    
    private var progressBarWidth: CGFloat
    
    private var barWidth: CGFloat
    
    fileprivate var currentVal: Int = 0
    
    public init(barColors: [UIColor], marker: UIView? = nil , markerLabelTitle: String? = nil, currentValue: Int, showShowBarValues: Bool, progressBarWidth: CGFloat = 120) {
        
        self.barColors = barColors
        self.progressBarWidth = progressBarWidth
        self.barWidth = progressBarWidth / CGFloat(barColors.count)
        
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
    
    public var bgColor: UIColor = .clear {
        didSet {
            addMarker(marker: customMarker)
            layoutSubviews()
        }
    }
    
    public var markerColor: UIColor = UIColor.Label {
        didSet {
            layout()
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
            
            self.markerLabel.bottomAnchor.constraint(equalTo: self.markerView.topAnchor, constant: -self.labelToMarkerCushion),
            
            self.colorBarsStackView.bottomAnchor.constraint(equalTo: self.valueBarsStackView.topAnchor),
            self.colorBarsStackViewContainerView.heightAnchor.constraint(equalToConstant: self.progressBarOnlyHeight),
            self.colorBarsStackViewContainerView.widthAnchor.constraint(equalToConstant: self.progressBarWidth),
            self.colorBarsStackViewContainerView.bottomAnchor.constraint(equalTo: self.valueBarsStackView.topAnchor, constant: -self.colorsBarToValuesBarCushion),
            
            self.colorBarsStackView.topAnchor.constraint(equalTo: self.colorBarsStackViewContainerView.topAnchor),
            self.colorBarsStackView.bottomAnchor.constraint(equalTo: self.colorBarsStackViewContainerView.bottomAnchor),
            self.colorBarsStackView.widthAnchor.constraint(equalToConstant: self.progressBarWidth),
            
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
            colorBarsStackViewContainerView.layer.cornerRadius = barRadius
        }
        
        let increment: CGFloat = self.barWidth * CGFloat(currentVal)
        
        let markerFrame = CGRect(x: increment - (markerHeight / 2) - (barWidth / 2), y: 0, width: markerHeight, height: markerHeight)
        markerView.frame = markerFrame
        
        let markerLabelFrame = CGRect(x: 0, y: 0, width: 40, height: self.markerLabelViewHeight)
        markerLabel.frame = markerLabelFrame
        markerLabel.text = markerTitle
        markerLabel.sizeToFit()
        
        let viewHeight: CGFloat = valueBarsStackView.frame.height + colorBarsStackView.frame.height + markerView.frame.height + markerLabel.frame.height + markerToColorsBarCushion + colorsBarToValuesBarCushion + labelToMarkerCushion
        
        let mainFrame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: viewHeight)
        self.view.frame = mainFrame
        self.frame = mainFrame
        
        updateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func addMarker(marker: UIView?) {
        if let marker = marker {
            self.markerView.addSubview(marker)
        } else {
            let triangleView = CardPartTriangleView(frame: CGRect(x: 0, y: 0, width: markerHeight, height: markerHeight))
            triangleView.fillColor = markerColor
            triangleView.backgroundColor = bgColor
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
}

extension Reactive where Base: CardPartProgressBarView {
    
    public var currentValue: Binder<Int> {
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
