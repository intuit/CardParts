//
//  CardPartTextField.swift
//  CardParts
//
//  Created by Kier, Tom on 12/14/17.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

public enum CardPartTextFieldFormat {
    case none
    case currency(maxLength: Int)
    case zipcode
    case phone
    case ssn
}

public class CardPartTextField : UITextField, CardPartView {
    
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    
    public var format: CardPartTextFieldFormat = .none {
        didSet {
            switch format {
            case let .currency(maxLength):
                self.maxLength = maxLength
            case .zipcode:
                maxLength = 10
            case .phone:
                maxLength = 12
            case .ssn:
                maxLength = 11
            default:
                maxLength = 0
            }
        }
    }
    public var maxLength = 0
    
    public var unformattedString: String? {
        if case .none = format {
            return super.text
        }
        return super.text?.uppercased().components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
    }
    
    override public var text: String? {
        set {
            super.text = newValue
            textDidChange()
        }
        get {
            if case .none = format {
                return super.text
            } else {
                textDidChange()
                return unformattedString
            }
        }
    }
    
    public init(format: CardPartTextFieldFormat = .none) {
        super.init(frame: CGRect.zero)
        
        setFormat(format: format)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChangeNotifcation(notification:)), name: UITextField.textDidChangeNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func textChangeNotifcation(notification: NSNotification) {
        if let notifObject = notification.object as? CardPartTextField, notifObject == self {
            textDidChange()
        }
    }
    
    func textDidChange() {
        if let superText = super.text, maxLength > 0, superText.count > maxLength {
            super.text = String(superText[..<superText.index(superText.startIndex, offsetBy: maxLength)])
        }

        switch format {
        case .currency:
            if let unformattedString = unformattedString {
                if unformattedString.count == 0 && placeholder != nil {
                    super.text = nil
                    return
                }
                super.text = formatCurrency(amount: Int(unformattedString) ?? 0)
            }
        case .zipcode:
            if let unformattedString = unformattedString {
                if unformattedString.count == 0 && placeholder != nil {
                    super.text = nil
                    return
                }
                super.text = formatZipCode(zip: unformattedString)
            }
        case .phone:
            if let unformattedString = unformattedString {
                if unformattedString.count == 0 && placeholder != nil {
                    super.text = nil
                    return
                }
                super.text = formatPhone(phone: unformattedString)
            }
        case .ssn:
            if let unformattedString = unformattedString {
                if unformattedString.count == 0 && placeholder != nil {
                    super.text = nil
                    return
                }
                super.text = formatSSN(ssn: unformattedString)
            }
        default:
            break
        }
    }
    
    func setFormat(format: CardPartTextFieldFormat) {
        self.format = format
    }
    
    func formatZipCode(zip: String) -> String {
        if zip.count > 5 {
            var formattedZip = zip
            formattedZip.insert("-", at: formattedZip.index(formattedZip.startIndex, offsetBy: 5))
            return formattedZip
        } else {
            return zip
        }
    }
    
    func formatCurrency(amount: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "USD"
        currencyFormatter.maximumFractionDigits = 0
        return currencyFormatter.string(from: NSNumber(value: amount)) ?? ""
    }

    func formatPhone(phone: String) -> String {
        if let num = Int(phone.stringWithOnlyNumbers()) {
            let nf = NumberFormatter()
            nf.groupingSize = 4
            nf.secondaryGroupingSize = 3
            nf.groupingSeparator = "-"
            nf.usesGroupingSeparator = true
            let formatted = nf.string(from: NSNumber(value: num))
            if let formattedString = formatted {
                return formattedString
            }
        }
        return phone
    }

    func formatSSN(ssn: String) -> String {
        var formattedSSN = ssn.stringWithOnlyNumbers()
        if formattedSSN.count > 3 {
            formattedSSN.insert("-", at: formattedSSN.index(formattedSSN.startIndex, offsetBy: 3))
            if formattedSSN.count > 6 {
                formattedSSN.insert("-", at: formattedSSN.index(formattedSSN.startIndex, offsetBy: 6))
            }
        }
        return formattedSSN
    }

}
