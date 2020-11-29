//
//  CompanyDetails.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

struct Details: Decodable {
    let open: String
    let high: String
    let low: String
    let price: String
    let volume: String
    let previosClose: String
    let change: String
    let changePercent: String
    
    enum CodingKeys: String, CodingKey {
        case open = "02. open"
        case high = "03. high"
        case low = "04. low"
        case price = "05. price"
        case volume = "06. volume"
        case previosClose = "08. previous close"
        case change =  "09. change"
        case changePercent = "10. change percent"
    }
}
