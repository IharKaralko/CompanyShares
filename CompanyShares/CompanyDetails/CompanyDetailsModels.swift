//
//  CompanyDetailsModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

enum CompanyDetails {
    struct Requst {
        let company: Company
    }
    
    struct Response {
        let name: String
        let companyResult: CompanyResult?
    }
    
    struct ViewModel {
        let name: String
        let companyResult: CompanyResult?
    }
}
