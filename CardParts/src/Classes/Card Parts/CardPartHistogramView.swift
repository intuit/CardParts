//
//  CardPartHistogram.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 10/28/19.
//

import Foundation
import CoreGraphics.CGGeometry
import UIKit

public enum HistogramLine {
    case lines(bottom:Bool,middle:Bool,top:Bool)
}

public enum Distribution {
    case fill
    case equalSpacing
}

public class CardPartHistogramView: UIView, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    /// contains all layers of the chart.
    private let mainLayer:CALayer = CALayer()
    
    /// contains main layer to suppor scrolling
    private let scrollView:UIScrollView = UIScrollView()
    
    /// A flag to indicate whether or not to animate the chart based on the entries.
    private var animated:Bool = false
    
    /// width of each of the bar item
    public var width:CGFloat = 20

    /// spacing between the items
    public var spacing:CGFloat = 10
    
    /// top space of histogram
    public var topSpace:CGFloat = 40
    
    /// bottom space of histogram
    public var bottomSpace:CGFloat = 40
    
    /// corner radius of each of the bar item
    public var cornerRadius:CGFloat = 4
    
    /// distribution of histogram
    public var distribution:Distribution = .fill
    
    /// should show horizontal lines
    public var shouldShowHorizontalLines:Bool = false
    
    /// is scroll enabled
    public var isScrollEnabled:Bool = true {
        didSet {
            scrollView.isScrollEnabled = isScrollEnabled
        }
    }

    /// shows all three lines of the bar graph
    public var histogramLines:HistogramLine = HistogramLine.lines(bottom: true, middle: true, top: true)
    
    /// Responsible for compute all positions and frames of all elements represent on the bar chart
    private var presenter:CardPartBarChart = CardPartBarChart(barWidth: 20, space: 10, topSpace: 40, bottomSpace: 40)
    
    /// height for the histogram to render
    public var intrinsicHeight:CGFloat = 450
    
    /// An array of bar entries. Each BasicBarEntry contain information about line segments, curved line segments, positions and frames of all elements on a bar.
    private var barEntries: [CardPartBarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            scrollView.contentSize = CGSize(width: presenter.computeContentWidth(), height: self.intrinsicHeight)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            
            if shouldShowHorizontalLines {
                showHorizontalLines()
            }
            
            for (index, entry) in barEntries.enumerated() {
                showEntry(index: index, entry: entry, animated: animated, oldEntry: oldValue.safeValue(at: index))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
        
        scrollView.layout {
            $0.leading == self.leadingAnchor
            $0.trailing == self.trailingAnchor
            $0.top == self.topAnchor
        }
        
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: self.intrinsicHeight)
        ])
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.updateDataEntries(dataEntries: presenter.dataEntries, animated: false)
    }
    
    public func updateDataEntries(dataEntries: [DataEntry], animated: Bool) {
        let space = self.distribution == .equalSpacing ? computeSpacing(dataEntries: dataEntries) : self.spacing
        self.presenter = CardPartBarChart(barWidth: self.width, space: space, topSpace: self.topSpace, bottomSpace: self.bottomSpace)
        self.animated = animated
        self.presenter.dataEntries = dataEntries
        self.barEntries = self.presenter.computeBarEntries(viewHeight: self.frame.height)
    }
    
    private func showEntry(index: Int, entry: CardPartBarEntry, animated: Bool, oldEntry: CardPartBarEntry?) {
        
        let cgColor = entry.data.color.cgColor
        
        // Show the main bar
        mainLayer.addRectangleLayer(frame: entry.barFrame, color: cgColor, animated: animated, oldFrame: oldEntry?.barFrame, cornerRadius: self.cornerRadius)
    }
    
    private func showHorizontalLines() {
          self.layer.sublayers?.forEach({
              if $0 is CAShapeLayer {
                  $0.removeFromSuperlayer()
              }
          })
        
        /// contains horizontal bottom, middle and top lines
        let lines = presenter.computeHorizontalLines(viewHeight: self.frame.height)

        if case let HistogramLine.lines(bottom,middle,top) = histogramLines {
            if bottom {
                guard let line = lines.first else  { return }
                mainLayer.addLineLayer(lineSegment: line.segment, color: UIColor.darkGray.cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
            }
            
            if middle {
                guard let line = lines.dropFirst().first else  { return }
                mainLayer.addLineLayer(lineSegment: line.segment, color: UIColor.darkGray.cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
            }
            
            if top {
                guard let line = lines.last else  { return }
                mainLayer.addLineLayer(lineSegment: line.segment, color: UIColor.darkGray.cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
            }
        }
    }
    
    func computeSpacing(dataEntries: [DataEntry]) -> CGFloat {
        scrollView.layoutIfNeeded()
        
        return (scrollView.bounds.width - (CGFloat(dataEntries.count) * width)) / (CGFloat(dataEntries.count) - 1)
    }
}

/// configures bar width , spacing , data entries and of each of those.
public class CardPartBarChart {
    /// width of the bar
    public var barWidth:CGFloat = 40
       
    /// space between bars
    public var space:CGFloat = 10
       
    /// space at the bottom of the bar to show the title
    public var bottomSpace: CGFloat = 40.0
       
    /// space at the top of each bar to show the value
    public var topSpace: CGFloat = 40.0
    
    /// Line padding
    private var linePadding:CGFloat = 6.5
    
    var dataEntries: [DataEntry] = []
       
    init(barWidth:CGFloat, space: CGFloat, topSpace: CGFloat, bottomSpace: CGFloat) {
        self.barWidth = barWidth
        self.space = space
        self.topSpace = topSpace
        self.bottomSpace = bottomSpace
    }
    
    /// width of the entire bars
    func computeContentWidth() -> CGFloat {
        return (barWidth + space) * CGFloat(dataEntries.count) + space
    }
    
    func computeBarEntries(viewHeight: CGFloat) -> [CardPartBarEntry] {
        var result:[CardPartBarEntry] = []
        for (index, entry) in dataEntries.enumerated() {
            let entryHeight = CGFloat(entry.height) * (viewHeight - bottomSpace - topSpace)
            let xPosition:CGFloat = CGFloat(index) * (barWidth + space)
            let yPosition:CGFloat = viewHeight - bottomSpace - entryHeight
            let origin = CGPoint(x: xPosition, y: yPosition)
            let barEntry = CardPartBarEntry(origin: origin, barWidth: barWidth, barHeight: entryHeight, space: space, data: entry)
            result.append(barEntry)
        }
        return result
    }
    
    func computeHorizontalLines(viewHeight: CGFloat) -> [HorizontalLine] {
        var result: [HorizontalLine] = []
        
        let horizontalLineInfos = [
            (value: CGFloat(0.0), isDashed: false),
            (value: CGFloat(0.5), isDashed: true),
            (value: CGFloat(1.0), isDashed: false)
        ]
        
        for lineInfo in horizontalLineInfos {
            let yPosition = viewHeight - bottomSpace -  lineInfo.value * (viewHeight - bottomSpace - topSpace) + linePadding
            
            let length = self.computeContentWidth()
            let lineSegment = LineSegment(
                startPoint: CGPoint(x: 0, y: yPosition),
                endPoint: CGPoint(x: length, y: yPosition)
            )
            let line = HorizontalLine(
                segment: lineSegment,
                isDashed: lineInfo.isDashed,
                width: 0.5)
            result.append(line)
        }
        
        return result
    }
}


/// holder for data to render the bar chart
public struct DataEntry {
    public let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    public let height: Float
    
    /// To be shown on top of the bar
    public let textValue: String
    
    /// To be shown at the bottom of the bar
    public let title: String
    
    public init(color: UIColor, height: Float, textValue: String , title: String) {
        self.color = color
        self.height = height
        self.textValue = textValue
        self.title = title
    }
}

/// calculates button , text and bar frames.
public struct CardPartBarEntry {
    let origin: CGPoint
    let barWidth: CGFloat
    let barHeight: CGFloat
    let space: CGFloat
    let data: DataEntry
    
    var bottomTitleFrame: CGRect {
        return CGRect(x: origin.x - space/2, y: origin.y + 10 + barHeight, width: barWidth + space, height: 22)
    }
    
    var textValueFrame: CGRect {
        return CGRect(x: origin.x - space/2, y: origin.y - 30, width: barWidth + space, height: 22)
    }
    
    var barFrame: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: barWidth, height: barHeight)
    }
}

struct HorizontalLine {
    let segment: LineSegment
    let isDashed: Bool
    let width: CGFloat
}

struct LineSegment {
    let startPoint: CGPoint
    let endPoint: CGPoint
}
