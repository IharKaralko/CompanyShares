//
//  DetailsResponse.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

struct DetailsResponse: Decodable {
    let globalQuote: Details
    
    enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
}
