//
//  CurrentPrice.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

class CurrentPrice {
    let price: String
    let date: Date
    
    init(price: String) {
        self.price = price
        self.date = Date()
    }
}
