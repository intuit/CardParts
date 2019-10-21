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

/// CardPartTableViewDelegate
@objc public protocol CardPartTableViewDelegate {
    /// didSelectRowAt
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    /// heightForRowAt
	@objc optional func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

///CardPartTableView displays a table view as a card part such that all items in the table view are displayed in the card part (i.e. the table view does not scroll). CardPartTableView leverages Bond's reactive data source support allowing a MutableObservableArray to be bound to the table view.
///
///To setup the data source binding the view model class should expose MutableObservableArray property that contains the table view's data. For example:
///```
///var listData = MutableObservableArray(["item 1", "item 2", "item 3", "item 4"])
///```
///Then in the view controller the data source binding can be setup as follows:
///```
///viewModel.listData.bind(to: tableViewPart.tableView) { listData, indexPath, tableView in
///    guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewPart.kDefaultCellId, for: indexPath) as? CardPartTableViewCell else { return UITableViewCell() }
///
///    cell.leftTitleLabel.text = listData[indexPath.row]
///    return cell
///}
///```
///The last parameter to the bind call is block that will be called when the tableview's cellForRowAt data source method is called. The first parameter to the block is the MutableObservableArray being bound to.
///
///CardPartTableView registers a default cell class (`CardPartTableViewCell`) that can be used with no additional work. CardPartTableViewCell contains 4 labels, a left justified title, left justified description, right justified title, and a right justified description. Each label can be optionally used, if no text is specified in a label the cell's layout code will correctly layout the remaining labels.
///
///It is also possible to register your own custom cells by calling the register method on `tableViewPart.tableView`.
///
///You also have access to two delegate methods being called by the tableView as follows:
///```
///@objc public protocol CardPartTableViewDelegate {
///    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
///    @objc optional func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
///}
///```
public class CardPartTableView : UIView, CardPartView, UITableViewDelegate {
	
	let kDefaultCellId = "CellId"
	
    /// CardParts theme margins by default
	public var margins: UIEdgeInsets = CardParts.theme.tableViewMargins
	
    /// tableView
	public var tableView: UITableView
	
    /// 60.0 by default
	public var rowHeight: CGFloat = 60
	
    /// CardPartTableViewDelegate
	public var delegate: CardPartTableViewDelegate?
	
    /// Initializes table, registering CardPartTableViewCell, with separator
	public init() {
		
		tableView = SelfSizingTableView(frame: CGRect.zero)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(CardPartTableViewCell.self, forCellReuseIdentifier: kDefaultCellId)
		tableView.isScrollEnabled = false
        tableView.separatorColor = UIColor.turboSeperatorColor
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
		
		super.init(frame: CGRect.zero)
		
		tableView.delegate = self
		addSubview(tableView)
		
		setNeedsUpdateConstraints()
	}
	
    /// Required init
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    /// IntrinsicContentSize
	override public var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: tableView.contentSize.height)
	}

    /// Update constraints, pinning
	override public func updateConstraints() {
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: ["tableView" : tableView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView" : tableView]))
		
		super.updateConstraints()
	}
	
    /// Asks the delegate for height or defaults to `rowHeight`
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return delegate?.tableView?(tableView, heightForRowAt: indexPath) ?? rowHeight
	}
	
    /// didSelectRowAt proxy to delegate
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.tableView(tableView, didSelectRowAt: indexPath)
	}
}
