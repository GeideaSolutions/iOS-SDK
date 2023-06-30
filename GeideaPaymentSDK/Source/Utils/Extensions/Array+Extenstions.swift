//
//  Array+Extenstions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 20/01/2021.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
    
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
    
}
