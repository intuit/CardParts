//
//  CardPartCollectionViewCardPartsCell.swift
//  CardParts
//
//  Created by Roossin, Chase on 3/7/18.
//

import Foundation

/// Just how `CardPartTableViewCell` has the ability to create tableView cells out of CardParts - so do CollectionViews. Below is an example of how you may create a custom `CardPartCollectionViewCardPartsCell`:
///```
///class MyCustomCollectionViewCell: CardPartCollectionViewCardPartsCell {
///    let bag = DisposeBag()
///
///    let mainSV = CardPartStackView()
///    let titleCP = CardPartTextView(type: .title)
///    let descriptionCP = CardPartTextView(type: .normal)
///
///    override init(frame: CGRect) {
///
///        super.init(frame: frame)
///
///        mainSV.axis = .vertical
///        mainSV.alignment = .center
///        mainSV.spacing = 10
///
///        mainSV.addArrangedSubview(titleCP)
///        mainSV.addArrangedSubview(descriptionCP)
///
///        setupCardParts([mainSV])
///    }
///
///    required init?(coder aDecoder: NSCoder) {
///        fatalError("init(coder:) has not been implemented")
///    }
///
///    func setData(_ data: MyStruct) {
///
///        titleCP.text = data.title
///        descriptionCP.text = data.description
///    }
///}
///```
///
/// To use this, you must register it to the CollectionView during viewDidLoad as follows:
///```
///collectionViewCardPart.collectionView.register(MyCustomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCustomCollectionViewCell")
///```
///
/// Then, inside your data source, simply dequeue this cell:
///```
///let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfSuggestedAccounts>(configureCell: {[weak self] (_, collectionView, indexPath, data) -> UICollectionViewCell in
///    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionViewCell", for: indexPath) as? MyCustomCollectionViewCell else { return UICollectionViewCell() }
///
///    cell.setData(data)
///    return cell
///})
///```
open class CardPartCollectionViewCardPartsCell : UICollectionViewCell {

    private var rightTopConstraint: NSLayoutConstraint!
    private var leftTopConstraint: NSLayoutConstraint!
    
    private var cardParts:[CardPartView] = []

    /// Initializes cell and removes any existing subviews
    override public init(frame: CGRect) {

        super.init(frame: .zero)

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }

        setNeedsUpdateConstraints()
    }

    /// Required init
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Initializes CardPartsViews and stacks them on top of each other, using the theming/margins
    public func setupCardParts(_ cardParts:[CardPartView]) {

        self.cardParts = cardParts
        
        var prevCardPart: UIView = contentView
        var padding: CGFloat = 0
        
        for cardPart in cardParts {
            cardPart.view.translatesAutoresizingMaskIntoConstraints = false
            padding += cardPart.margins.top
            
            if let _ = cardPart.viewController {
                // TODO add support for cardParts implemented as view controllers
                print("Viewcontroller card parts not supported in collection view cells")
            } else {
                contentView.addSubview(cardPart.view)
            }
            
            let metrics = ["leftMargin" : cardPart.margins.left - 28, "rightMargin" : cardPart.margins.right - 28]
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[cardPartView]-rightMargin-|", options: [], metrics: metrics, views: ["cardPartView" : cardPart.view!]))
            if prevCardPart == contentView {
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[cardPartView]", options: [], metrics: ["padding" : padding], views: ["cardPartView" : cardPart.view!]))
            } else {
                contentView.addConstraints([NSLayoutConstraint(item: cardPart.view!, attribute: .top, relatedBy: .equal, toItem: prevCardPart, attribute: .bottom, multiplier: 1.0, constant: padding)])
            }
            
            prevCardPart = cardPart.view
            padding = cardPart.margins.bottom
            
        }
    }
}
