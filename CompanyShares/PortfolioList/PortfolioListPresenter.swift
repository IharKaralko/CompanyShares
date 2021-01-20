//
//  PortfolioListPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import UIKit

protocol PortfolioListPresentationLogic {
    func presentPortfolios(_ responses: [PortfolioList.Response])
}

class PortfolioListPresenter {
    weak var viewController: PortfolioListDisplayLogic?
}

// MARK: - PortfolioListPresentationLogic
extension PortfolioListPresenter: PortfolioListPresentationLogic {
    func presentPortfolios(_ responses: [PortfolioList.Response]) {
        var portfoliosWithPrices = [PortfolioWithPrices]()
        for response in responses {
            let purchasePriceFormat = String(format: "%.2f", response.purchasePrice)
            let priceAndChange = Utility.getAttributedString(purchasePrice: response.purchasePrice, currentPrice: response.currentPrice, isTotalPrice: false)
            let portfolioWithPrices = PortfolioWithPrices(portfolio: response.portfolio, purchasePrice: purchasePriceFormat, priceAndChange: priceAndChange)
            portfoliosWithPrices.append(portfolioWithPrices)
        }
        let viewModel = PortfolioList.ViewModel(portfoliosWithPrice: portfoliosWithPrices)
        viewController?.displayPortfolioList(viewModel: viewModel)
    }
}
