//
//  CompanyPorfolioModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation

enum CompanyPortfolioList {
    struct Response {
        let portfoliosWithPrice: [PortfolioWithPrices]
    }
    
    struct ViewModel {
        let portfoliosWithPrice: [PortfolioWithPrices]
        
    }
}
