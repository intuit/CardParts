//
//  CardPartCollectionView.swift
//  Alamofire
//
//  Created by Roossin, Chase on 3/7/18.
//

import UIKit
import RxSwift
import RxCocoa

@objc public protocol CardPartCollectionViewDelegte {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

public class CardPartCollectionView : UIView, CardPartView, UICollectionViewDelegate {

    let kDefaultCellId = "CellId"

    public var margins: UIEdgeInsets = CardParts.theme.tableViewMargins

    public var collectionView: UICollectionView

    public var delegate: CardPartCollectionViewDelegte?

    public init(collectionViewLayout: UICollectionViewLayout? = nil) {

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout ?? UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true

        super.init(frame: CGRect.zero)

        collectionView.delegate = self
        addSubview(collectionView)

        setNeedsUpdateConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: collectionView.frame.height)
    }

    override public func updateConstraints() {

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView" : collectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView" : collectionView]))

        super.updateConstraints()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
