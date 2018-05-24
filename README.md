<p align="center">
    <img src="images/cardPartsLogo.png" width="300" alt="Mint Logo"/>
</p>

<p align="center"> </p>

[![Version](https://img.shields.io/cocoapods/v/CardParts.svg?style=flat)](http://cocoapods.org/pods/CardParts)
[![License](https://img.shields.io/cocoapods/l/CardParts.svg?style=flat)](http://cocoapods.org/pods/CardParts)
[![Platform](https://img.shields.io/cocoapods/p/CardParts.svg?style=flat)](http://cocoapods.org/pods/CardParts)

<p align="center">
    <img src="images/mintCardParts.gif" width="300" alt="CardParts in Mint"/>
    &nbsp;
    &nbsp;
    &nbsp;
    &nbsp;
    <img src="images/turboCardParts.gif" width="300" alt="CardParts in Turbo"/>
</p>

CardParts - made with ❤️ by Intuit:
- [Example](#example)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication & Contribution](#communication-and-contribution)
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
    - [CardsViewController](#cardsviewcontroller)
    - [Card Traits](#card-traits)
        - [NoTopBottomMarginsCardTrait](#notopbottommarginscardtrait)
        - [TransparentCardTrait](#transparentcardtrait)
        - [EditableCardTrait](#editablecardtrait)
        - [HiddenCardTrait](#hiddencardtrait)
        - [ShadowCardTrait](#shadowcardtrait)
        - [RoundedCardTrait](#roundedcardtrait)
        - [GradientCardTrait](#gradientcardtrait)
    - [CardPartsViewController](#cardpartsviewcontroller)
    - [CardPartsFullScreenViewController](#cardpartsfullscreenviewcontroller)
    - [Card Parts](#card-parts)
        - [CardPartTextView](#cardparttextview)
        - [CardPartImageView](#cardpartimageview)
        - [CardPartButtonView](#cardpartbuttonview)
        - [CardPartTitleView](#cardparttitleview)
        - [CardPartSeparatorView](#cardpartseparatorview)
        - [CardPartVerticalSeparatorView](#cardpartverticalseparatorview)
        - [CardPartTableView](#cardparttableview)
        - [CardPartTableViewCell](#cardparttableviewcell)
        - [CardPartTableViewCardPartsCell](#cardparttableviewcardpartscell)
        - [CardPartCollectionView](#cardpartcollectionview)
        - [CardPartCollectionViewCardPartsCell](#cardpartcollectionviewcardpartcell)
        - [CardPartBarView](#cardpartbarview)
        - [CardPartPagedView](#cardpartpagedview)
        - [CardPartSliderView](#cardpartsliderview)
        - [CardPartSpacerView](#cardpartspacerview)
        - [CardPartTextField](#cardparttextfield)
    - [Card States](#card-states)
    - [Data Binding](#data-binding)
    - [Themes](#themes)
- [Apps That Love CardParts](#apps-that-love-cardparts)
- [License](#license)

# Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

In `ViewController.swift` you will be able to change the cards displayed and/or their order by commenting out one of the `loadCards(cards: )` functions.
If you want to change the content of any of these cards, you can look into each of the `CardPartsViewController` you pass into the function such as: `TestCardController`, `Thing1CardController`, `Thing2CardController`, etc.

# Requirements
- iOS 10.0+
- Xcode 9.2+
- Swift 4.0+

# Installation

CardParts is available through [CocoaPods](http://cocoapods.org). You can install it with the following command:

```bash
$ gem install cocoapods
```

To add CardParts to your project, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'CardParts'
end
```

Then, run the following command:

```bash
$ pod install
```

# Communication and Contribution

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cardparts). (Tag 'cardparts')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cardparts).
- If you **found a bug**, open an issue and tag as `bug`.
- If you **have a feature request**, open an issue and tag as `feature`.
- If you **want to contribute**, submit a pull request.
    - In order to submit a pull request, please fork this repo and submit a PR from your forked repo.
    - Have a detailed message as to what your PR fixes/enhances/adds.
    - Each PR must get two approvals from our team before we will merge.

# Overview
CardParts is the second generation Card UI framework for the iOS Mint application. This version includes many updates to the original card part framework, including improved MVVM, data binding (via [RxSwift](https://github.com/ReactiveX/RxSwift)), use of stack views and self sizing collection views instead sizing cells, 100% swift and much more. The result is a much simpler, easier to use, more powerful, and easier to maintain framework. This framework is currently used by the iOS Mint application and the iOS Turbo application.

<p align="center">
    <img src="images/cardPartExample.png" alt="CardPart Example in Mint"/>
</p>

# Quick Start
See how quickly you can get a card displayed on the screen while adhering to the MVVM design pattern:
```swift
class MyCardsViewController: CardsViewController {
 
    let cards: [CardController] = [TestCardController()]

    override func viewDidLoad() {
        super.viewDidLoad()
		
        loadCards(cards: cards)
    }
}

class TestCardController: CardPartsViewController  {
    
    var viewModel = TestViewModel()
    var titlePart = CardPartTitleView(type: .titleOnly)
    var textPart = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.title.asObservable().bind(to: titlePart.reactive.title).disposed(by: bag)
        viewModel.text.asObservable().bind(to: textPart.reactive.text).disposed(by: bag)

        setupCardParts([titlePart, textPart])
    }
}

class TestViewModel {

    var title = Variable("")
    var text = Variable("")

    init() {

        // When these values change, the UI in the TestCardController 
        // will automatically update
        title.value = "Hello, world!"
        text.value = "CardParts is awesome!"
    }
}
```

# Architecture
There are two major parts to the card parts framework. The first is the `CardsViewController` which will display the cards. It is responsible for displaying cards in the proper order and managing the lifetime of the cards. The second major component is the cards themselves which are typically instances of `CardPartsViewController`. Each instance of `CardPartsViewController` displays the content of a single card, using one or more card parts (more details later).

## `CardsViewController`
The `CardsViewController` uses a collection view where each cell is a single card. The cells will render the frames for the cards, but are designed to have a child ViewController that will display the contents of the card. Thus `CardsViewController` is essentially a list of child view controllers that are rendered in special cells that draw the card frames.

To use a `CardsViewController`, you first need to subclass it. Then in the `viewDidLoad` method call the super class `loadCards` method passing an array of `CardController`s. Each instance of a `CardController` will be rendered as a single card. The `loadCards` method does this by getting the view controller for each `CardController` and adding them as child view controllers to the card cells. Here is an example:

```swift
class TestCardsViewController: CardsViewController {
 
    let cards: [CardController] = [TestCardController(), AnotherTestCardController()]

    override func viewDidLoad() {
        super.viewDidLoad()
		
        loadCards(cards: cards)
    }
}
```

Each card must implement the CardController protocol (note that `CardPartsViewController` discussed later implements this protocol already). The
CardController protocol has a single method:
```swift
protocol CardController : NSObjectProtocol {
    
    func viewController() -> UIViewController
    
}
```
The viewController() method must return the viewController that will be added as a child controller to the card cell. If the CardController is a UIViewController it can simply return self for this method. 

## Card Traits
The Card Parts framework defines a set of traits that can be used to modify the appearance and behavior of cards. These traits are implemented as a protocols and protocol extensions. To add a trait to a card simply add the trait protocol to the CardController definition. For example:
```swift
class MyCard: UIViewController, CardController, TransparentCardTrait {
    
}
```
MyCard will now render itself with a transparent card background and frame. No extra code is needed, just adding the TransparentCardTrait as a protocol is all that is necessary. 

Most traits require no extra code. The default protocol extensions implemented by the framework implement all the code required for the trait to modify the card. A few traits do require implementing an function or property. See the documentation for each trait below for more information.

#### `NoTopBottomMarginsCardTrait`
By default each card has margin at the top and bottom of the card frame. Adding the NoTopBottomMarginsCardTrait trait will remove that margin allowing the card to render to use the entire space inside the card frame.

#### `TransparentCardTrait`
Each card is rendered with a frame that draws the border around the card. Adding TransparentCardTrait will not display that border allowing the card to render without a frame.

#### `EditableCardTrait`
If the EditableCardTrait trait is added, the card will be rendered with an edit button in upper right of the card. When user taps in the edit button, the framework will call the cards _onEditButtonTap()_ method.  The EditableCardTrait protocol requires the CardController to implement the _onEditButtonTap()_ method.

#### `HiddenCardTrait`
The HiddenCardTrait trait requires the CardController to implement an isHidden variable:
```swift
    var isHidden: Variable<Bool> { get }
```
The framework will then observer the isHidden variable so that whenever its value is changed the card will be hidden or shown based upon the new value. This allows the CardController to control its visibility by simply modifying the value of its isHidden variable.

#### `ShadowCardTrait`
The ShadowCardTrait protocol requires CardController to implement `shadowColor()`, `shadowRadius()` and `shadowOpacity()` methods.
```swift
    func shadowColor() -> CGColor {
        return UIColor.lightGray.cgColor
    }

    func shadowRadius() -> CGFloat {
        return 10.0
    }

    // The value can be from 0.0 to 1.0.
    // 0.0 => lighter shadow
    // 1.0 => darker shadow
    func shadowOpacity() -> Float {
        return 1.0
    }
```

<p align="center">
shadowColor: lightGray, shadowRadius: 5.0, shadowOpacity: 0.5 <br/>
<img src="images/shadow_5.png" width="300" alt="Shadow radius 5.0"/>
</p>

<p align="center">
shadowColor: lightGray, shadowRadius: 10.0, shadowOpacity: 0.5 <br/>
<img src="images/shadow_10.png" width="300" alt="Shadow radius 10.0"/>
</p>

#### `RoundedCardTrait`
Use this protocol to define the roundness for the card by implementing the method `cornerRadius()`.
```swift
    func cornerRadius() -> CGFloat {
        return 10.0
    }
```
<p align="center">
cornerRadius: 10.0 <br/>
<img src="images/shadow_5.png" width="300" alt="Shadow radius 5.0"/>
</p>

#### `GradientCardTrait`
Use this protocol to add a gradient background for the card. The gradients will be added vertically from top to bottom.
```swift
    func gradientColors() -> [UIColor] {
        return [UIColor.lavender, UIColor.aqua]
    }
```
<p align="center">
<img src="images/gradient.png" width="300" alt="Shadow radius 10.0"/>
</p>

## `CardPartsViewController`
CardPartsViewController implements the CardController protocol and builds its card UI by displaying one or more card part views using an MVVM pattern that includes automatic data binding. Each CardPartsViewController displays a list of CardPartView as its subviews.  Each CardPartView renders as a row in the card. The CardParts framework implements several different types of CardPartView that display basic views, such as title, text, image, button, separator, etc.  All CardPartView implemented by the framework are already styled to correctly match the applied themes UI guidelines.

In addition to the card parts, a CardPartsViewController also uses a view model to expose data properties that are bound to the card parts. The view model should contain all the business logic for the card, thus keeping the role of the CardPartsViewController to just creating its view parts and setting up bindings from the view model to the card parts. A simple implementation of a CardPartsViewController based card might look like the following:
```swift
class TestCardController: CardPartsViewController  {
    
    var viewModel = TestViewModel()
    var titlePart = CardPartTitleView(type: .titleOnly)
    var textPart = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.title.asObservable().bind(to: titlePart.reactive.title).disposed(by: bag)
        viewModel.text.asObservable().bind(to: textPart.reactive.text).disposed(by: bag)

        setupCardParts([titlePart, textPart])
    }
}

class TestViewModel {

    var title = Variable("")
    var text = Variable("")

    init() {

        // When these values change, the UI in the TestCardController 
        // will automatically update
        title.value = "Hello, world!"
        text.value = "CardParts is awesome!"
    }
}
```
The above example creates a card that displays two card parts, a title card part and a text part. The bind calls setup automatic data binding between view model properties and the card part view properties so that whenever the view model properties change, the card part views will automatically update with the correct data.

The call to setupCardParts adds the card part views to the card. It takes an array of CardPartView that specifies which card parts to display, and in what order to display them.

## `CardPartsFullScreenViewController`
This will make the card a full screen view controller.  So if you do not want to build with an array of Cards, instead you can make a singular card full-screen.
```swift
class TestCardController: CardPartsFullScreenViewController  {
    ...
}
```

## Card Parts
The framework includes several predefined card parts that are ready to use.  It is also possible to create custom card parts. The following sections list all the predefined card parts and their reactive properties that can be bound to view models.

#### `CardPartTextView`
CardPartTextView displays a single text string. The string can wrap to multiple lines. The initializer for CardPartTextView takes a type parameter which can be set to: normal, title, or detail. The type is used to set the default font and textColor for the text.

CardPartTextView exposes the following reactive properties that can be bound to view model properties:
```swift
var text: String?
var attributedText: NSAttributedString?
var font: UIFont!
var textColor: UIColor!
var textAlignment: NSTextAlignment
var lineSpacing: CGFloat
var lineHeightMultiple: CGFloat
var alpha: CGFloat
var backgroundColor: UIColor?
var isHidden: Bool
var isUserInteractionEnabled: Bool
var tintColor: UIColor?
```
#### `CardPartImageView`
CardPartImageView displays a single image.
CardPartImageView exposes the following reactive properties that can be bound to view model properties:
```swift
var image: UIImage?
var imageName: String?
var alpha: CGFloat
var backgroundColor: UIColor?
var isHidden: Bool
var isUserInteractionEnabled: Bool
var tintColor: UIColor?
```
#### `CardPartButtonView`
CardPartButtonView displays a single button.

CardPartButtonView exposes the following reactive properties that can be bound to view model properties:
```swift
var title: String?
var isSelected: Bool?
var isHighlighted: Bool?
var contentHorizontalAlignment: UIControlContentHorizontalAlignment
var alpha: CGFloat
var backgroundColor: UIColor?
var isHidden: Bool
var isUserInteractionEnabled: Bool
var tintColor: UIColor?
```
#### `CardPartTitleView`
CardPartTitleView displays a view with a title, and an optional options menu. The initializer requires a type parameter which can be set to either titleOnly or titleWithMenu. If the type is set to titleWithMenu the card part will display a menu icon, that when tapped will display a menu containing the options specified in the menuOptions array. The menuOptionObserver property can be set to a block that will be called when the user selects an item from the menu.

CardPartButtonView exposes the following reactive properties that can be bound to view model properties:
```swift
var title: String?
var titleFont: UIFont
var titleColor: UIColor
var menuTitle: String?
var menuOptions: [String]?
var menuButtonImageName: String
var alpha: CGFloat
var backgroundColor: UIColor?
var isHidden: Bool
var isUserInteractionEnabled: Bool
var tintColor: UIColor?
```
#### `CardPartSeparatorView`
CardPartSeparatorView displays a separator line.  There are no reactive properties define for CardPartSeparatorView.

#### `CardPartVerticalSeparatorView`
As the name describes, it shows a vertical separator view opposed to a horizontal one

#### `CardPartStackView`
CardPartSeparatorView displays a UIStackView that can contain other card parts, and even other CardPartStackViews. Using CardPartStackView allows for creating custom layouts of card parts. By nesting CardPartStackViews you can create almost any layout.

To add a card part to the stack view call its addArrangedSubview method, specifying the card part's view property as the view to be added to the stack view. For example:
```swift
horizStackPart.addArrangedSubview(imagePart)
```

There are no reactive properties defined for CardPartStackView. However you can use the default UIStackView properties (distribution, alignment, spacing, and axis) to configure the stack view.

#### `CardPartTableView`
CardPartTableView displays a table view as a card part such that all items in the table view are displayed in the card part (i.e. the table view does not scroll). CardPartTableView leverages Bond's reactive data source support allowing a MutableObservableArray to be bound to the table view. 

To setup the data source binding the view model class should expose MutableObservableArray property that contains the table view's data.  For example:
```swift
var listData = MutableObservableArray(["item 1", "item 2", "item 3", "item 4"])
```
Then in the view controller the data source binding can be setup as follows:
```swift
viewModel.listData.bind(to: tableViewPart.tableView) { listData, indexPath, tableView in
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewPart.kDefaultCellId, for: indexPath) as? CardPartTableViewCell else { return UITableViewCell() }

    cell.leftTitleLabel.text = listData[indexPath.row]
    
    return cell
}
```
The last parameter to the bind call is block that will be called when the tableview's cellForRowAt data source method is called. The first parameter to the block is the MutableObservableArray being bound to.

CardPartTableView registers a default cell class (CardPartTableViewCell) that can be used with no additional work. CardPartTableViewCell contains 4 labels, a left justified title, left justified description, right justified title, and a right justified description. Each label can be optionally used, if no text is specified in a label the cell's layout code will correctly layout the remaining labels.

It is also possible to register your own custom cells by calling the register method on `tableViewPart.tableView`.

You also have access to two delegate methods being called by the tableView as follows:
```swift
@objc public protocol CardPartTableViewDelegte {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	@objc optional func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}
```

#### `CardPartTableViewCell`
CardPartTableViewCell is the default cell registered for CardPartTableView. The cell contains the following properties:
```swift
var leftTitleLabel: UILabel
var leftDescriptionLabel: UILabel
var rightTitleLabel: UILabel
var rightDescriptionLabel: UILabel
var rightTopButton: UIButton
var shouldCenterRightLabel = false
var leftTitleFont: UIFont
var leftDescriptionFont: UIFont
var rightTitleFont: UIFont
var rightDescriptionFont: UIFont
var leftTitleColor: UIColor
var leftDescriptionColor: UIColor
var rightTitleColor: UIColor
var rightDescriptionColor: UIColor
```

#### `CardPartTableViewCardPartsCell`
This will give you the ability to create custom tableView cells out of CardParts.  The following code allows you to create a cell:

```swift
class MyCustomTableViewCell: CardPartTableViewCardPartsCell {
    
    let bag = DisposeBag()
    
    let attrHeader1 = CardPartTextView(type: .normal)
    let attrHeader2 = CardPartTextView(type: .normal)
    let attrHeader3 = CardPartTextView(type: .normal)
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupCardParts([attrHeader1, attrHeader2, attrHeader3])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: MyCustomStruct) {
        // Do something in here
    }
}
```

If you do create a custom cell, you must register it to the `CardPartTableView`:
```swift
tableViewCardPart.tableView.register(MyCustomTableViewCell.self, forCellReuseIdentifier: "MyCustomTableViewCell")
```

And then as normal, you would bind to your viewModel's data:
```swift
viewModel.listData.bind(to: tableViewPart.tableView) { tableView, indexPath, data in
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomTableViewCell", for: indexPath) as? MyCustomTableViewCell else { return UITableViewCell() }

    cell.setData(data)
    
    return cell
}
```
#### `CardPartCollectionView`
CardPartCollectionView underlying engine is [RxDataSource](https://github.com/RxSwiftCommunity/RxDataSources). You can look at their documentation for a deeper look but here is an overall approach to how it works:

Start by initializing a `CardPartCollectionView` with a custom `UICollectionViewFlowLayout`:

```swift
lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: collectionViewLayout)
var collectionViewLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 12
    layout.minimumLineSpacing = 12
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 96, height: 128)
    return layout
}()
```

Now say you have a custom struct you want to pass into your CollectionViewCell:
```swift
struct MyStruct {
    var title: String
    var description: String
}
```

You will need to create a new struct to conform to `SectionModelType`:
```swift
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
```
Next, create a data source that you will bind to you data:
_Note: You can create a custom CardPartCollectionViewCell as well - see below._
```swift
let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomStruct>(configureCell: {[weak self] (_, collectionView, indexPath, data) -> UICollectionViewCell in

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

    return cell
})
```

Finally, bind your viewModel data to the collectionView and its newly created data source:
```swift
viewModel.data.asObservable().bind(to: collectionViewCardPart.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
```

_Note: `viewModel.data` will be a reactive array of `SectionOfCustomStruct`_:
```swift
typealias ReactiveSection = Variable<[SectionOfCustomStruct]>
var data = ReactiveSection([])
```

#### `CardPartCollectionViewCardPartsCell`
Just how CardPartTableViewCell has the ability to create tableView cells out of CardParts - so do CollectionViews.  Below is an example of how you may create a custom `CardPartCollectionViewCardPartsCell`:

```swift
class MyCustomCollectionViewCell: CardPartCollectionViewCardPartsCell {
    let bag = DisposeBag()

    let mainSV = CardPartStackView()
    let titleCP = CardPartTextView(type: .title)
    let descriptionCP = CardPartTextView(type: .normal)

    override init(frame: CGRect) {

        super.init(frame: frame)

        mainSV.axis = .vertical
        mainSV.alignment = .center
        mainSV.spacing = 10

        mainSV.addArrangedSubview(imageCP)
        mainSV.addArrangedSubview(descriptionCP)

        setupCardParts([mainSV])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: MyStruct) {

        titleCP.text = data.title
        descriptionCP.text = data.description
    }
}
```

To use this, you must register it to the CollectionView during `viewDidLoad` as follows:
```swift
collectionViewCardPart.collectionView.register(MyCustomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCustomCollectionViewCell")
```

Then, inside your data source, simply dequeue this cell:
```swift
let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfSuggestedAccounts>(configureCell: {[weak self] (_, collectionView, indexPath, data) -> UICollectionViewCell in

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionViewCell", for: indexPath) as? MyCustomCollectionViewCell else { return UICollectionViewCell() }

    cell.setData(data)

    return cell
})
```

#### `CardPartBarView`
CardPartBarView present a horizontal bar graph that can be filled to a certain percentage of your choice. Both the color of the fill and the percent is reactive
```swift
let barView = CardPartBarView()
viewModel.percent.asObservable().bind(to: barView.rx.percent).disposed(by:bag)
viewModel.barColor.asObservable().bind(to: barView.rx.barColor).disposed(by: bag)
```

#### `CardPartPagedView`
This CardPart allows you to create a horizontal paged carousel with page controls.  Simply feed it with your desired height and an array of `CardPartStackView`:
```swift
let cardPartPages = CardPartPagedView(withPages: initialPages, andHeight: desiredHeight)
cardPartPages.delegate = self
```
This CardPart also has a delegate:
```swift
func didMoveToPage(page: Int)
```
Which will fire whenever the user swipes to another page

#### `CardPartSliderView`
You can set min and max value as well as bind to the current set amount:
```swift
let slider = CardPartSliderView()
slider.minimumValue = sliderViewModel.min
slider.maximumValue = sliderViewModel.max
slider.value = sliderViewModel.defaultAmount
slider.rx.value.asObservable().bind(to: sliderViewModel.amount).disposed(by: bag)
``` 

#### `CardPartSpacerView`
Allows you to add a space between card parts incase you need a space larger than the default margin.  Initiliaze it with a specific height:
```swift
CardPartSpacerView(height: 30)
```

#### `CardPartTextField`
CardPartTextField can take a parameter of type `CardPartTextFieldFormat` which determines formatting for the UITextField.  You may also set properties such as `keyboardType`, `placeholder`, `font`, `text`, etc.

```swift
let amount = CardPartTextField(format: .phone)
amount.keyboardType = .numberPad
amount.placeholder = textViewModel.placeholder
amount.font = dataFont
amount.textColor = UIColor.colorFromHex(0x3a3f47)
amount.text = textViewModel.text.value
amount.rx.text.orEmpty.bind(to: textViewModel.text).disposed(by: bag)
```

The different formats are as follows:
```swift
public enum CardPartTextFieldFormat {
    case none
    case currency(maxLength: Int)
    case zipcode
    case phone
    case ssn
}
```

## Card States
CardPartsViewController can optionally support the notion of card states, where a card can be in 3 different states: loading, empty, and hasData. For each state you can specify a unique set of card parts to display. Then when the CardPartsViewController state property is changed, the framework will automatically switch the card parts to display the card parts for that state. Typically you would bind the state property to a state property in your view model so that when the view model changes state the card parts are changed. A simple example:

```swift
class TestCardController : CardPartsViewController  {
    
    var viewModel = TestViewModel()
    var titlePart = CardPartTitleView(type: .titleOnly)
    var textPart = CardPartTextView(type: .normal)
    var loadingText = CardPartTextView(type: .normal)
    var emptyText = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.title.asObservable().bind(to: titlePart.reactive.title).disposed(by: bag)
        viewModel.text.asObservable().bind(to: textPart.reactive.text).disposed(by: bag)

        loadingText.text = "Loading..."
        emptyText.text = "No data found."

        viewModel.state.asObservable().bind(to: self.rx.state).disposed(by: bag)

        setupCardParts([titlePart, textPart], forState: .hasData)
        setupCardParts([titlePart, loadingText], forState: .loading)
        setupCardParts([titlePart, emptyText], forState: .empty)
    }
}
```

## Data Binding
Data binding is implemented using the RxSwift library (https://github.com/ReactiveX/RxSwift). View models should expose their data as bindable properties using the Variable class. In the example above the view model might look like this:
```swift
class TestViewModel {
    
    var title = Variable("Testing")
    var text = Variable("Card Part Text")
}
```
Later when the view model's data has changed it can update its property by setting the value attribute of the property:
```swift
title.value = “Hello”
```
The view controller can bind the view model property to a view:
```swift
viewModel.title.asObservable().bind(to: titlePart.rx.title).disposed(by: bag)
```
Now, whenever the view model's title property value is changed it will automatically update the titlePart's title. 

RxSwift use the concept of "Disposable" and "DisposeBag" to remove bindings. Each call to bind returns a Disposable that can be added to a DisposeBag. CardPartsViewController defines an instance of DisposeBag called "bag" that you can use to automatically remove all your bindings when your CardPartsViewController is deallocated. See the RxSwift documentation for more information on disposables and DisposeBags.

## Themes
Out of the box we support 2 themes: Mint and Turbo.  These are the 2 Intuit app's that are currently built ontop of CardParts.  As you can find in the file `CardPartsTheme.swift` we have a protocol called `CardPartsTheme`.  You may create a class that conforms to `CardPartsTheme` and set all properties in order to theme CardParts however you may like. Below is an example of some of the themeable properties:
```swift
// CardPartTextView
var smallTextFont: UIFont { get set }
var smallTextColor: UIColor { get set }
var normalTextFont: UIFont { get set }
var normalTextColor: UIColor { get set }
var titleTextFont: UIFont { get set }
var titleTextColor: UIColor { get set }
var headerTextFont: UIFont { get set }
var headerTextColor: UIColor { get set }
var detailTextFont: UIFont { get set }
var detailTextColor: UIColor { get set }

// CardPartTitleView
var titleFont: UIFont { get set }
var titleColor: UIColor { get set }

// CardPartButtonView
var buttonTitleFont: UIFont { get set }
var buttonTitleColor: UIColor { get set }
var tableViewMargins: UIEdgeInsets { get set }
```
### Applying a theme
Generate a class as follows:
```swift
public class YourCardPartTheme: CardPartsTheme {
    ...
}
```
And then in your `AppDelegete` call `YourCardPartTheme().apply()` it apply your theme.

## Listeners
Card Parts also support a listener that allows you to listen to visibility changes in the cards that you have created. In your `CardPartsViewController` you may override the following function to gain insight into the visibility of your card within the `CardsViewController` you have created.
```swift
public class YourCardPartsViewController: CardPartsViewController {
    ...

    // Notifies your card parts view controller of the percentage of the card that is visible.
    // This function is called every time 'scrollViewDidScroll' is called in your CardsViewController.
    override func cardVisibility(percentVisible: CGFloat) {
        // logic you would like to perform when the scroll view has scrolled
    }
}
```

# Apps That Love CardParts
- [Mint - Personal Finance & Money](https://itunes.apple.com/us/app/mint-personal-finance-money/id300238550?mt=8)
- [Turbo: Scores-Income & Credit](https://itunes.apple.com/us/app/turbo-scores-income-credit/id1242998361?mt=8)
- More to come.. hopefully!
# License

CardParts is available under the Apache 2.0 license. See the LICENSE file for more info.
