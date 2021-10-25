//
//  Array.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 10/28/19.
//

import Foundation

extension Array {
    func safeValue(at index: Int) -> Element? {
        guard index >= 0, index < count else {
            return nil
        }
        return self[index]
    }
}

