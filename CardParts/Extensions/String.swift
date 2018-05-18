//
//  String.swift
//  CardParts
//
//  Created by Kier, Tom on 3/15/18.
//

import UIKit
import Foundation

extension String {
        
    func stringWithOnlyNumbers() -> String {
        return self.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
    }
    
    func matchesRegex(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let results = regex.matches(in: self, range: NSRange(startIndex..., in: self))
            
            return results.count == 1 && results[0].range.length == count
        } catch {
            return false
        }
    }
    
}

