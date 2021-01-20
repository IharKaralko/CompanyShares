//
//  BuyAndSellSharesInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

protocol BuyAndSellSharesBusinessLogic: class {
    func loadPrice(_ request: BuyAndSellShares.LoadPrice.Request)
    func addShare(_ request: BuyAndSellShares.AddShare.Request)
    func removeShare(_ request: BuyAndSellShares.RemoveShare.Request)
    func updateShareAmount(_ request: BuyAndSellShares.UpdateShareAmount.Request)
    func showResultOfSale(_ request: BuyAndSellShares.ShowResultOfSale.Request)
}

class BuyAndSellSharesInteractor {
    var presenter: BuyAndSellSharesPresentationLogic?
    var worker: CompanyDetailsWorkingLogic?
    var dataSourceOfShare: DataSourceOfShareProtocol?
}

// MARK: - BuyAndSellSharesBusinessLogic
extension BuyAndSellSharesInteractor: BuyAndSellSharesBusinessLogic {
    func showResultOfSale(_ request: BuyAndSellShares.ShowResultOfSale.Request) {
        let purchasePrice = request.share.purchasePrice * Double(request.amount)
        let currentPrice = request.price * Double(request.amount)
        let response = BuyAndSellShares.ShowResultOfSale.Response(purchasePrice: purchasePrice, currentPrice: currentPrice)
        presenter?.presentResultOfSale(response: response)
    }
    
    func updateShareAmount(_ request: BuyAndSellShares.UpdateShareAmount.Request) {
        dataSourceOfShare?.update(share: request.share, currentPrice: nil, amount: request.amount)
    }
    
    func removeShare(_ request: BuyAndSellShares.RemoveShare.Request) {
        dataSourceOfShare?.remove(share: request.share)
    }
    
    func addShare(_ request: BuyAndSellShares.AddShare.Request) {
        dataSourceOfShare?.createShare(request.newShare)
    }
    
    func loadPrice(_ request: BuyAndSellShares.LoadPrice.Request) {
        worker?.fetchDetails(keyword: request.symbol) { [weak self] details, error in
            let response: BuyAndSellShares.LoadPrice.Response
            if let details = details {
                response = BuyAndSellShares.LoadPrice.Response(price: details.price)
                self?.presenter?.presentPrice(response: response)
            } else {
                response =  BuyAndSellShares.LoadPrice.Response(price: "BuyAndSellShares_Not_available".localized)
                self?.presenter?.presentPrice(response: response)
            }
        }
    }
}
