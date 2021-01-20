//
//  PortfolioSharesPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import UIKit

protocol PortfolioSharesPresentationLogic {
    func presentShares(response: PortfolioShares.Response)
}

class PortfolioSharesPresenter {
    weak var viewController: PortfolioSharesDisplayLogic?
}

// MARK: - PortfolioSharesPresentationLogic
extension PortfolioSharesPresenter: PortfolioSharesPresentationLogic {
    func presentShares(response: PortfolioShares.Response) {
        var sharesWithPrices = [ShareWithPrices]()
        for share in response.shares {
            let totalPurchase = share.purchasePrice * Double(share.amount)
            let totalCurrentPrice = share.currentPrice * Double(share.amount)
            let totalPriceAndChange = Utility.getAttributedString(purchasePrice: totalPurchase, currentPrice: totalCurrentPrice, isTotalPrice: true)
            let priceAndChange = Utility.getAttributedString(purchasePrice: share.purchasePrice, currentPrice: share.currentPrice, isTotalPrice: false)
            let shareWithPrices = ShareWithPrices(share: share, totalPriceAndChange: totalPriceAndChange, priceAndChange: priceAndChange)
            sharesWithPrices.append(shareWithPrices)
        }
        let viewModel = PortfolioShares.ViewModel(shares: sharesWithPrices)
        viewController?.displayShares(viewModel: viewModel)
    }
}
