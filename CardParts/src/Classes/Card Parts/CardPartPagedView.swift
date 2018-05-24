//
//  CardPartPagedView.swift
//  Gala
//
//  Created by Roossin, Chase on 4/25/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import Foundation
import UIKit

public protocol CardPartPagedViewDelegate {
	func didMoveToPage(page: Int)
}

public class CardPartPagedView: UIView, CardPartView {
	
	public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
	
	public var pages: [CardPartView]! {
		didSet {
			DispatchQueue.main.async{ [weak self] in
                self?.invalidateIntrinsicContentSize()
                self?.scrollView.setNeedsLayout()
                self?.scrollView.layoutIfNeeded()
                self?.updatePageControl()
			}
		}
	}
	
	public var currentPage: Int {
		didSet{
			updatePageControl()
		}
	}
	
	public var delegate: CardPartPagedViewDelegate?
	
	fileprivate var pageControl: UIPageControl
	fileprivate var scrollView: UIScrollView
	fileprivate var height: CGFloat
	
	public init(withPages pages: [CardPartStackView], andHeight height: CGFloat) {
		
		scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 250, height: height))
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.backgroundColor = UIColor.clear
		scrollView.isScrollEnabled = true
		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		self.height = height
		
		pageControl = UIPageControl(frame: .zero)
		pageControl.translatesAutoresizingMaskIntoConstraints = false
		pageControl.pageIndicatorTintColor = UIColor.lightGray
		pageControl.currentPageIndicatorTintColor = UIColor.darkGray
		
		currentPage = 0
		
		super.init(frame: .zero)
		
		addSubview(scrollView)
		addSubview(pageControl)
		
		setNeedsUpdateConstraints()
		scrollView.invalidateIntrinsicContentSize()
		scrollView.setNeedsLayout()
		scrollView.layoutIfNeeded()
		scrollView.delegate = self
		
		self.pages = pages
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updatePageControl()
    }
	
	override public func updateConstraints() {
		let metrics = ["height": height]
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[scrollView(height)]-40-|", options: [], metrics: metrics, views: ["scrollView" : scrollView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[scrollView]-20-|", options: [], metrics: metrics, views: ["scrollView" : scrollView]))
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pageControl]|", options: [], metrics: metrics, views: ["pageControl" : pageControl]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageControl]|", options: [], metrics: metrics, views: ["pageControl" : pageControl]))
		
		super.updateConstraints()
	}
	
	fileprivate func updatePageControl() {

		var frame = CGRect.zero
		
		scrollView.subviews.forEach({ $0.removeFromSuperview() })
		
		pageControl.numberOfPages = pages.count
		pageControl.currentPage = currentPage
		
		for (index, page) in pages.enumerated() {
			
			frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
			frame.size = self.scrollView.frame.size
			
			page.view.frame = frame
			self.scrollView.addSubview(page.view)
		}
		
		self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(pages.count), height: self.scrollView.frame.size.height)
	}
}

extension CardPartPagedView: UIScrollViewDelegate {
	
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		
		let pageWidth:CGFloat = scrollView.frame.width
		let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
		self.pageControl.currentPage = Int(currentPage);
		delegate?.didMoveToPage(page: Int(currentPage))
	}
}
