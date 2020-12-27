//
//  CompanyPortfolioSharesPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import UIKit

protocol CompanyPortfolioSharesPresentationLogic {
    func presentShares(response: CompanyPortfolioShares.Response)
}

class CompanyPortfolioSharesPresenter {
    weak var viewController: CompanyPortfolioSharesDisplayLogic?
}

// MARK: - CompanyPortfolioListPresentationLogic
extension CompanyPortfolioSharesPresenter: CompanyPortfolioSharesPresentationLogic {
    func presentShares(response: CompanyPortfolioShares.Response) {
        var sharesWithPrices = [ShareWithPrices]()
        for share in response.shares {
            let totalPurchase = share.purchasePrice * Double(share.count)
            let totalCurrentPrice = share.currentPrice * Double(share.count)
            
        let totalPriceAndChange = getAttributedString(purchasePrice: totalPurchase, currentPrice: totalCurrentPrice)
            
        let priceAndChange = getAttributedString(purchasePrice: share.purchasePrice, currentPrice: share.currentPrice)
            let shareWithPrices = ShareWithPrices(share: share, totalPriceAndChange: totalPriceAndChange, priceAndChange: priceAndChange)
            sharesWithPrices.append(shareWithPrices)
        }
        let viewModel = CompanyPortfolioShares.ViewModel(shares: sharesWithPrices)
        viewController?.displayShares(viewModel: viewModel)
    }
    
    
    
    
    func getAttributedString(purchasePrice: Double, currentPrice: Double) -> NSMutableAttributedString {
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
        let changePercent = (change / purchasePrice) * 100
        let changeString = String(format: "%.2f", change)
        let changePercentString = String(format: "%.2f", changePercent)
        
        let changeItog = "  " + changeString + " (" + changePercentString + "%)"
        let attributedChange = NSMutableAttributedString(string: changeItog, attributes: attrs)
        attributedString.append(attributedChange)
        return attributedString
    }
    
}
