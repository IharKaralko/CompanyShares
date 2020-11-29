//
//  CompanyDetailsModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

enum CompanyDetails {
    struct Requst {
        let symbol: String
    }
    
    struct Response {
        let companyResult: CompanyResult
    }
    
    struct ViewModel {
        let companyResult: CompanyResult
    }
}
