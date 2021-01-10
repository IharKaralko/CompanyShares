//
//  PortfolioSharesModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import Foundation

enum PortfolioShares {
    struct Response {
        let shares: [Share]
    }
    
    struct ViewModel {
        let shares: [ShareWithPrices] 
    }
}
