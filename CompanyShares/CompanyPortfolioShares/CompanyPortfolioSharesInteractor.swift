//
//  CompanyPortfolioSharesInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import Foundation

protocol CompanyPortfolioSharesBusinessLogic: class {
    func fetchShares(porfolio: Portfolio)
    func remove(share: Share)
    func addShare(symbol: String, count: Int64, price: Double, portfolio: Portfolio)
}

class CompanyPortfolioSharesInteractor {
    var presenter: CompanyPortfolioSharesPresentationLogic?
    var worker: CompanyPortfolioListWorkingLogic?
    var dataSourceOfShares: DataSourceOfShareProtocol?
}

// MARK: - CompanyPortfolioSharesBusinessLogic
extension CompanyPortfolioSharesInteractor: CompanyPortfolioSharesBusinessLogic {
    func fetchShares(porfolio: Portfolio) {
        guard let shares = dataSourceOfShares?.getShares(portfolio: porfolio) else { return }
        getCurrentPrice(shares: shares) {
            let response = CompanyPortfolioShares.Response(shares: shares)
            self.presenter?.presentShares(response: response)
        }
    }
    
    func remove(share: Share) {
        dataSourceOfShares?.remove(share: share)
    }
    
    func addShare(symbol: String, count: Int64, price: Double, portfolio: Portfolio) {
        dataSourceOfShares?.createShare(name: symbol, count: count, purchasePrice: price, portfolio: portfolio)
        fetchShares(porfolio: portfolio)
    }
}

private extension CompanyPortfolioSharesInteractor {
    func getCurrentPrice(shares: [Share],  completion: @escaping () -> Void) {
        let userListDispatchGroup = DispatchGroup()
        for share in shares {
            guard let symbol = share.symbol else { return }
            userListDispatchGroup.enter()
            worker?.fetchPrice(keyword: symbol) {
                price, error in
                if let currentPrice = price {
                    share.currentPrice = currentPrice.price
                } else {
                    share.currentPrice = 0
                }
                userListDispatchGroup.leave()
            }
        }
        userListDispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
