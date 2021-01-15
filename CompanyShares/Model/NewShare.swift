//
//  NewShare.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/14/21.
//

import Foundation

struct NewShare {
    let symbol: String
    let amount: Int64
    let purchasePrice: Double
    var currentPrice: Double
    let portfolio: Portfolio
}
