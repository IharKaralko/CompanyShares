//
//  Company.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/18/20.
//

import Foundation
import RealmSwift

class Company: Object, Decodable {
    @objc dynamic var symbol = ""
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
    
    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
    }
}
