//
//  CardPartTableView.swift
//  Gala
//
//  Created by Kier, Tom on 2/22/17.
//  Copyright © 2017 Mint.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private class SelfSizingTableView: UITableView {
	
	override var contentSize: CGSize {
		didSet {
			superview?.invalidateIntrinsicContentSize()
			if let parent = parentViewController() as? CardPartsViewController, let cardsViewController = parent.parent as? CardsViewController {
				cardsViewController.invalidateLayout()
			}
		}
	}
	
	func parentViewController() -> UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
}

@objc public protocol CardPartTableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	@objc optional func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

public class CardPartTableView : UIView, CardPartView, UITableViewDelegate {
	
	let kDefaultCellId = "CellId"
	
	public var margins: UIEdgeInsets = CardParts.theme.tableViewMargins
	
	public var tableView: UITableView
	
	public var rowHeight: CGFloat = 60
	
	public var delegate: CardPartTableViewDelegate?
	
	public init() {
		
		tableView = SelfSizingTableView(frame: CGRect.zero)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(CardPartTableViewCell.self, forCellReuseIdentifier: kDefaultCellId)
		tableView.isScrollEnabled = false
        tableView.separatorColor = CardParts.theme.separatorColor
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
		
		super.init(frame: CGRect.zero)
		
		tableView.delegate = self
		addSubview(tableView)
		
		setNeedsUpdateConstraints()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: tableView.contentSize.height)
	}

	override public func updateConstraints() {
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: ["tableView" : tableView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView" : tableView]))
		
		super.updateConstraints()
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return delegate?.tableView?(tableView, heightForRowAt: indexPath) ?? rowHeight
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.tableView(tableView, didSelectRowAt: indexPath)
	}
}
