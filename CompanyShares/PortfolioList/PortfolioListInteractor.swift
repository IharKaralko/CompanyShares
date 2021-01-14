//
//  PortfolioListInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import UIKit

protocol PortfolioListBusinessLogic: class {
    func fetchPortfolios()
    func remove(portfolio: Portfolio)
    func addPortfolio(name: String)
    func update(portfolio: Portfolio, name: String)
}

class PortfolioListInteractor {
    var presenter: PortfolioListPresentationLogic?
   // var worker: PortfolioListWorkingLogic?
    var worker: CompanyDetailsWorkingLogic?
    var dataSourceOfPortfolio: DataSourceOfPortfolioProtocol?
    var dataSourceOfShares: DataSourceOfShareProtocol?
}

// MARK: - PortfolioListBusinessLogic
extension PortfolioListInteractor: PortfolioListBusinessLogic {
    func fetchPortfolios() {
        var responses = [PortfolioList.Response]()
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
                    let response = PortfolioList.Response(portfolio: portfolio, purchasePrice: purchasePrice, currentPrice: currentPrice)
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

private extension PortfolioListInteractor {
    func getCurrentPrice(shares: [Share], completion: @escaping (Double) -> Void) {
        let userListDispatchGroup = DispatchGroup()
        for share in shares {
            guard let symbol = share.symbol, let date = share.date else { return }
            if Date().timeIntervalSince(date) > 300 {
            userListDispatchGroup.enter()
                worker?.fetchDetails(keyword: symbol) { [weak self] details, error in
                    if let details = details {
                        share.currentPrice = Double(details.price) ?? 0
                        self?.dataSourceOfShares?.update(share: share, currentPrice: share.currentPrice, date: Date())
                    }
                    //  worker?.fetchPrice(keyword: symbol) {
//                price, error in
//                if let currentPrice = price {
//                    share.currentPrice = currentPrice.price
//                } else {
//                    share.currentPrice = 0
//                }
                userListDispatchGroup.leave()
            }
        }
        }
        userListDispatchGroup.notify(queue: .main) {
            let currentPrice = shares.reduce(0) { $0 + $1.currentPrice * Double($1.count) }
            completion(currentPrice)
        }
    }
}
