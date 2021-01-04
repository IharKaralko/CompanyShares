//
//  CompanyDetailsModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

enum CompanyDetails {
    struct Requst {
        let company: SelectedCompany
    }
    
    struct Response {
        let company: SelectedCompany
        let details: Details?
    }
    
    struct ViewModel {
        let name: String
        let companyResult: CompanyResult?
    }
}
