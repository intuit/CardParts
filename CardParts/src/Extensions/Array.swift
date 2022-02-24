//
//  Array.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 10/28/19.
//

import Foundation

extension Array {
    /// read an array element at a given `index` safely
    /// - Parameter index: the index of the element to read
    /// - Returns: array element at a given `index`. `nil` if index is out of range
    func safeValue(at index: Int) -> Element? {
        guard index >= 0, index < count else {
            return nil
        }
        return self[index]
    }
}

