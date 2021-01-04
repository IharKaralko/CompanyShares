//
//  CompanyPortfolioListInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import UIKit

protocol CompanyPortfolioListBusinessLogic: class {
    func fetchPortfolios()
    func remove(portfolio: Portfolio)
    func addPortfolio(name: String)
    func update(portfolio: Portfolio, name: String)
}

class CompanyPortfolioListInteractor {
    var presenter: CompanyPortfolioListPresentationLogic?
    var worker: CompanyPortfolioListWorkingLogic?
    var dataSourceOfPortfolio: DataSourceOfPortfolioProtocol?
    var dataSourceOfShares: DataSourceOfShareProtocol?
}

// MARK: - CompanyPortfolioListBusinessLogic
extension CompanyPortfolioListInteractor: CompanyPortfolioListBusinessLogic {
    func fetchPortfolios() {
        var responses = [CompanyPortfolioList.Response]()
        guard let portfolios = dataSourceOfPortfolio?.getPortfolios() else { return }
        let userListDispatchGroup = DispatchGroup()
        
        for portfolio in portfolios {
            let shares = dataSourceOfShares?.getShares(portfolio: portfolio)
            let purchasePrice = shares?.reduce(0) { $0 + $1.purchasePrice * Double($1.count)} ?? 0
            var currentPrice: Double = 0
            if let shares = shares {
                userListDispatchGroup.enter()
                getCurrentPrice(shares: shares) { current in
                    currentPrice = current
                    let response = CompanyPortfolioList.Response(portfolio: portfolio, purchasePrice: purchasePrice, currentPrice: currentPrice)
                    responses.append(response)
                    userListDispatchGroup.leave()
                }
            }
        }
        userListDispatchGroup.notify(queue: .main) {
            self.presenter?.presentPortfolios(responses)
        }
    }
    
    func remove(portfolio: Portfolio) {
        dataSourceOfPortfolio?.remove(portfolio: portfolio)
    }
    
    func addPortfolio(name: String) {
        dataSourceOfPortfolio?.createPortfolio(name: name)
        fetchPortfolios()
    }
    
    func update(portfolio: Portfolio, name: String) {
        dataSourceOfPortfolio?.update(portfolio: portfolio, name: name)
    }
}

private extension CompanyPortfolioListInteractor {
    func getCurrentPrice(shares: [Share], completion: @escaping (Double) -> Void) {
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
            let currentPrice = shares.reduce(0) { $0 + $1.currentPrice * Double($1.count) }
            completion(currentPrice)
        }
    }
}
