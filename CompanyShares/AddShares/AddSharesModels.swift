//
//  AddSharesModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

enum  AddShares {
    struct Requst {
        let newShare: NewShare
    }
    
    struct Response {
        let price: String
    }
    
    struct ViewModel {
        let price: String
    }
}
