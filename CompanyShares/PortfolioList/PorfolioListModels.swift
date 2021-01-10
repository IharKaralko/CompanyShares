//
//  PorfolioListModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation

enum PortfolioList {
    struct Response {
        let portfolio: Portfolio
        let purchasePrice: Double
        let currentPrice: Double
    }
    
    struct ViewModel {
        let portfoliosWithPrice: [PortfolioWithPrices]
    }
}
