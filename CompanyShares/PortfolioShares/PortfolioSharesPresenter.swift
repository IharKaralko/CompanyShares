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
            let totalPriceAndChange = getAttributedString(purchasePrice: totalPurchase, currentPrice: totalCurrentPrice, isTotalPrice: true)
            let priceAndChange = getAttributedString(purchasePrice: share.purchasePrice, currentPrice: share.currentPrice, isTotalPrice: false)
            let shareWithPrices = ShareWithPrices(share: share, totalPriceAndChange: totalPriceAndChange, priceAndChange: priceAndChange)
            sharesWithPrices.append(shareWithPrices)
        }
        let viewModel = PortfolioShares.ViewModel(shares: sharesWithPrices)
        viewController?.displayShares(viewModel: viewModel)
    }
}

private extension PortfolioSharesPresenter {
    func getAttributedString(purchasePrice: Double, currentPrice: Double, isTotalPrice: Bool) -> NSMutableAttributedString {
        let currentPriceString = String(format: "%.2f", currentPrice)
        let attributedString = NSMutableAttributedString(string: currentPriceString, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        var attrs: [NSAttributedString.Key : Any]
        
        if purchasePrice > currentPrice {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.red]
        }
        else {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        }
        
        let change = currentPrice - purchasePrice
        let changePercent = purchasePrice > 0 ? (change / purchasePrice) * 100 : 0
        let changeString = String(format: "%.2f", change)
        let changePercentString = String(format: "%.2f", changePercent)
        let changeItog: String
        if purchasePrice > 0 && !isTotalPrice {
            changeItog = "  " + changeString + " (" + changePercentString + "%)"
        } else {
            changeItog = "  " + changeString
        }
        
        let attributedChange = NSMutableAttributedString(string: changeItog, attributes: attrs)
        attributedString.append(attributedChange)
        return attributedString
    }
}
