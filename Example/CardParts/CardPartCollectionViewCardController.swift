//
//  CardPartCollectionViewCardController.swift
//  CardParts_Example
//
//  Created by Roossin, Chase on 5/23/18.
//  Copyright © 2018 Intuit. All rights reserved.
//

import Foundation
import CardParts
import RxSwift
import RxDataSources
import RxCocoa

struct MyStruct {
    var title: String
    var description: String
}

struct SectionOfCustomStruct {
    var header: String
    var items: [Item]
}

extension SectionOfCustomStruct: SectionModelType {
    
    typealias Item = MyStruct
    
    init(original: SectionOfCustomStruct, items: [Item]) {
        self = original
        self.items = items
    }
}

class CardPartCollectionViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: self.collectionViewLayout)
    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 96, height: 128)
        return layout
    }()
    let viewModel = CardPartCollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartCollectionView"

        collectionViewCardPart.collectionView.register(MyCustomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCustomCollectionViewCell")
        collectionViewCardPart.collectionView.backgroundColor = .clear
        collectionViewCardPart.collectionView.showsHorizontalScrollIndicator = false

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomStruct>(configureCell: { (_, collectionView, indexPath, data) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionViewCell", for: indexPath) as? MyCustomCollectionViewCell else { return UICollectionViewCell() }

            cell.setData(data)
            
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 1
            
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor.quaternarySystemFill
                cell.borderColor = UIColor.separator
            } else {
                cell.backgroundColor = UIColor.lightGray
            }
            
            return cell
        })
        
        viewModel.data.asObservable().bind(to: collectionViewCardPart.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)

        collectionViewCardPart.collectionView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        setupCardParts([cardPartTextView, collectionViewCardPart])
    }
}

class CardPartCollectionViewModel {
    
    typealias ReactiveSection = BehaviorRelay<[SectionOfCustomStruct]>
    var data = ReactiveSection(value: [])
    
    let emojis: [String] = ["😎", "🤪", "🤩", "👻", "🤟🏽", "💋", "💃🏽"]
    
    init() {
    
        var temp: [MyStruct] = []
        
        for i in 0...10 {
            
            temp.append(MyStruct(title: "Title #\(i)", description: "\(emojis[Int(arc4random_uniform(UInt32(emojis.count)))])"))
        }
        
        data.accept([SectionOfCustomStruct(header: "", items: temp)])
    }
}

class MyCustomCollectionViewCell: CardPartCollectionViewCardPartsCell {
    let bag = DisposeBag()
    
    let titleCP = CardPartTextView(type: .title)
    let descriptionCP = CardPartTextView(type: .normal)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        titleCP.margins = .init(top: 50, left: 20, bottom: 5, right: 30)
        descriptionCP.margins = .init(top: 15, left: 30, bottom: 0, right: 20)
        setupCardParts([titleCP, descriptionCP])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: MyStruct) {
        
        titleCP.text = data.title
        titleCP.textAlignment = .center
        
        descriptionCP.text = data.description
        descriptionCP.textAlignment = .center
        
        if #available(iOS 13.0, *) {
            titleCP.textColor = .label
            descriptionCP.textColor = .secondaryLabel
        } else {
            titleCP.textColor = .white
            descriptionCP.textColor = .white
        }
    }
}
