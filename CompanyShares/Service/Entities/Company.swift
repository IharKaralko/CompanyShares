//
//  Company.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/18/20.
//

import Foundation

struct Company: Decodable {
    let symbol: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
    }
}
