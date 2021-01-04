//
//  CompanyCollectionModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/3/20.
//

import Foundation

enum CompanyCollection {
    struct Response {
        let companies: [SelectedCompany]
    }
    
    struct ViewModel {
        let companies: [SelectedCompany]
    }
}
