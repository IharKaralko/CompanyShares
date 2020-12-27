//
//  Price.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation
struct Price: Decodable {
    let price: Double
    
    enum CodingKeys: String, CodingKey {
    case price = "c"
   }
}
