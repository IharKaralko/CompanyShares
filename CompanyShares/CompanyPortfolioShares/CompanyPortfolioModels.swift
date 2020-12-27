//
//  CompanyPortfolioModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import Foundation

enum CompanyPortfolioShares{
    struct Response {
        let shares: [Share]
    }
    
    struct ViewModel {
        let shares: [ShareWithPrices] 
    }
}
