//
//  BuyAndSellSharesPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import UIKit

protocol BuyAndSellSharesPresentationLogic {
    func presentPrice(response: BuyAndSellShares.LoadPrice.Response)
    func presentResultOfSale(response: BuyAndSellShares.ShowResultOfSale.Response)
}

class BuyAndSellSharesPresenter {
    weak var viewController: BuyAndSellSharesDisplayLogic?
}

// MARK: - BuyAndSellSharesPresentationLogic
extension BuyAndSellSharesPresenter: BuyAndSellSharesPresentationLogic {
    func presentResultOfSale(response: BuyAndSellShares.ShowResultOfSale.Response) {
        let result = Utility.getAttributedString(purchasePrice: response.purchasePrice, currentPrice: response.currentPrice, isTotalPrice: false)
        let viewModel = BuyAndSellShares.ShowResultOfSale.ViewModel(result: result)
        viewController?.displayResult(viewModel: viewModel)
    }
    
    func presentPrice(response: BuyAndSellShares.LoadPrice.Response) {
        let viewModel = BuyAndSellShares.LoadPrice.ViewModel(price: response.price)
        viewController?.displayPrice(viewModel:viewModel)
    }
}
