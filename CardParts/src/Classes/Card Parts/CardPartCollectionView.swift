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

/// CardPartCollectionView underlying engine is <a href="https://github.com/RxSwiftCommunity/RxDataSources" target="_blank">RxDataSource</a>. You can look at their documentation for a deeper look but here is an overall approach to how it works:
///
///Start by initializing a `CardPartCollectionView` with a custom `UICollectionViewFlowLayout`:
///
///```
///lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: collectionViewLayout)
///var collectionViewLayout: UICollectionViewFlowLayout = {
///    let layout = UICollectionViewFlowLayout()
///    layout.minimumInteritemSpacing = 12
///    layout.minimumLineSpacing = 12
///    layout.scrollDirection = .horizontal
///    layout.itemSize = CGSize(width: 96, height: 128)
///    return layout
///}()
///```
///
/// Now say you have a custom struct you want to pass into your CollectionViewCell:
///```
///struct MyStruct {
///    var title: String
///    var description: String
///}
///```
///
/// You will need to create a new struct to conform to `SectionModelType`:
///```
///struct SectionOfCustomStruct {
///    var header: String
///    var items: [Item]
///}
///
///extension SectionOfCustomStruct: SectionModelType {
///
///    typealias Item = MyStruct
///
///    init(original: SectionOfCustomStruct, items: [Item]) {
///        self = original
///        self.items = items
///    }
///}
///```
///
/// Next, create a data source that you will bind to your data: Note: You can create a custom `CardPartCollectionViewCell` as well.
///```
///let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomStruct>(configureCell: {[weak self] (_, collectionView, indexPath, data) -> UICollectionViewCell in
///    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
///    return cell
///})
///```
///
/// Finally, bind your viewModel data to the collectionView and its newly created data source:
///```
///viewModel.data.asObservable().bind(to: collectionViewCardPart.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
///```
///
/// Note: `viewModel.data` will be a reactive array of `SectionOfCustomStruct`:
///```
///typealias ReactiveSection = BehaviorRelay<[SectionOfCustomStruct]>
///var data = ReactiveSection(value: [])
///```
public class CardPartCollectionView : UIView, CardPartView, UICollectionViewDelegate {

    let kDefaultCellId = "CellId"

    /// CardPart theme tableViewMargins by default
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
