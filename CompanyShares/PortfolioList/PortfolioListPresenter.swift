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
            let priceAndChange = self.getAttributedString(purchasePrice: response.purchasePrice, currentPrice: response.currentPrice)
            let portfolioWithPrices = PortfolioWithPrices(portfolio: response.portfolio, purchasePrice: purchasePriceFormat, priceAndChange: priceAndChange)
            portfoliosWithPrices.append(portfolioWithPrices)
        }
        let viewModel = PortfolioList.ViewModel(portfoliosWithPrice: portfoliosWithPrices)
        viewController?.displayPortfolioList(viewModel: viewModel)
    }
}

private extension PortfolioListPresenter {
    func getAttributedString(purchasePrice: Double, currentPrice: Double) -> NSMutableAttributedString {
        let currentPriceString = String(format: "%.2f", currentPrice)
        let attributedString = NSMutableAttributedString(string: currentPriceString, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        var attrs: [NSAttributedString.Key : Any]
        
        if purchasePrice > currentPrice {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.red]
        } else {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        }
        
        let change = currentPrice - purchasePrice
        let changePercent = purchasePrice > 0 ? (change / purchasePrice) * 100 : 0
        let changeString = String(format: "%.2f", change)
        let changePercentString = String(format: "%.2f", changePercent)
        
        let changeItog = purchasePrice > 0 ? " " + changeString + " (" + changePercentString + "%)" : " " + changeString
        let attributedChange = NSMutableAttributedString(string: changeItog, attributes: attrs)
        attributedString.append(attributedChange)
        return attributedString
    }
}
