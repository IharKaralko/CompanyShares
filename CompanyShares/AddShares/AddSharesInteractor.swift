//
//  AddSharesInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

protocol AddSharesBusinessLogic: class {
    func loadPrice(symbol: String)
    func addShare(symbol: String, count: Int64, price: Double, portfolio: Portfolio)
}

class AddSharesInteractor {
    var presenter: AddSharesPresentationLogic?
    let cache = NSCache<NSString, CurrentPrice>()
    var worker: CompanyDetailsWorkingLogic?
    var dataSourceOfShares: DataSourceOfShareProtocol?
}

// MARK: - AddSharesBusinessLogic
extension AddSharesInteractor: AddSharesBusinessLogic {
    func addShare(symbol: String, count: Int64, price: Double, portfolio: Portfolio) {
        var currentPrice: Double = 0
        worker?.fetchDetails(keyword: symbol) { [weak self] details, error in
            if let details = details {
                currentPrice = Double(details.price) ?? 0
            }
            self?.dataSourceOfShares?.createShare(name: symbol, count: count, purchasePrice: price, currentPrice: currentPrice, portfolio: portfolio)
        }
    }
    
    func loadPrice(symbol: String) {
        if let currentPrice = cache.object(forKey: symbol as NSString), currentPrice.date.timeIntervalSince(Date()) < 600 {
            let response = AddShares.Response(price: currentPrice.price)
            print(symbol)
            presenter?.presentPrice(response: response)
            } else {
            worker?.fetchDetails(keyword: symbol) { [weak self] details, error in
                let response: AddShares.Response
                if let details = details {
                    response = AddShares.Response(price: details.price)
                    let currentPrice = CurrentPrice(price: details.price)
                    self?.cache.setObject(currentPrice, forKey: symbol as NSString)
                    self?.presenter?.presentPrice(response: response)
                } else {
                    response =  AddShares.Response(price: "Not available".localized)
                    self?.presenter?.presentPrice(response: response)
                }
            }
        }
    }
}
