//
//  CompanyListModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/19/20.
//

import Foundation

enum CompanyList {
    struct Requst {
        let keyword: String
    }
    
    struct Response {
        let companies: [Company]
    }
    
    struct ViewModel {
        let companies: [Company]
    }
}
