//
//  Array.swift
//  CardParts
//
//  Created by Venkatnarayansetty, Badarinath on 10/28/19.
//

import Foundation

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
}

