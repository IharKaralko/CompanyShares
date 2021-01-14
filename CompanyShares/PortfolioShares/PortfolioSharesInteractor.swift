//
//  PortfolioSharesInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import Foundation

protocol PortfolioSharesBusinessLogic: class {
    func fetchShares(porfolio: Portfolio)
    func remove(share: Share)
   // func addShare(symbol: String, count: Int64, purchasePrice: Double, portfolio: Portfolio)
}

class PortfolioSharesInteractor {
    var presenter: PortfolioSharesPresentationLogic?
  //  var worker: PortfolioListWorkingLogic?
    var worker: CompanyDetailsWorkingLogic?
    var dataSourceOfShares: DataSourceOfShareProtocol?
}

// MARK: - PortfolioSharesBusinessLogic
extension PortfolioSharesInteractor: PortfolioSharesBusinessLogic {
    func fetchShares(porfolio: Portfolio) {
        guard let shares = dataSourceOfShares?.getShares(portfolio: porfolio) else { return }
        getCurrentPrice(shares: shares) {
            let response = PortfolioShares.Response(shares: shares)
            self.presenter?.presentShares(response: response)
        }
    }
    
    func remove(share: Share) {
        dataSourceOfShares?.remove(share: share)
    }
    
//    func addShare(symbol: String, count: Int64, purchasePrice: Double, portfolio: Portfolio) {
//        var currentPrice: Double = 0
//        worker?.fetchPrice(keyword: symbol) { [weak self]
//            price, error in
//            if let price = price {
//                currentPrice = price.price
//            }
////            } else {
////                share.currentPrice = 0
////            }
//            self?.dataSourceOfShares?.createShare(name: symbol, count: count, purchasePrice: purchasePrice, currentPrice: currentPrice, portfolio: portfolio)
//            self?.fetchShares(porfolio: portfolio)
//
//        }
//         //   dataSourceOfShares?.createShare(name: symbol, count: count, purchasePrice: price, portfolio: portfolio)
//
//         //   fetchShares(porfolio: portfolio)
//    }
}

private extension PortfolioSharesInteractor {
    func getCurrentPrice(shares: [Share],  completion: @escaping () -> Void) {
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
//            worker?.fetchPrice(keyword: symbol) {
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
            completion()
        }
    }
}
