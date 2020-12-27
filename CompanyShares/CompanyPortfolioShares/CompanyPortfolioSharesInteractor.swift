//
//  CompanyPortfolioSharesInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import Foundation

protocol CompanyPortfolioSharesBusinessLogic: class {
    func fetchShares(porfolio: Portfolio)
    func removeShare(share: Share)
    func addShare(symbol: String, count: Int64, price: Double, portfolio: Portfolio)
  //  func updatePortfolio(portfolio: Portfolio, name: String)
}

class CompanyPortfolioSharesInteractor {
  var presenter: CompanyPortfolioSharesPresentationLogic?
    var worker: CompanyPortfolioSharesWorkingLogic?
    
   // var dataSourceOfPortfolio: DataSourceOfPortfolioProtocol?
    var dataSourceOfShares: DataSourceOfShare?
    
}

// MARK: - CompanyPortfolioListBusinessLogic
extension CompanyPortfolioSharesInteractor: CompanyPortfolioSharesBusinessLogic {
    func fetchShares(porfolio: Portfolio) {
//        var portfoliosWithPrices = [PortfolioWithPrices]()
//        guard let portfolios = dataSourceOfPortfolio?.getPortfolios() else { return }
//
//        for portfolio in portfolios {
        guard let shares = dataSourceOfShares?.getShares(portfolio: porfolio) else { return }
        getCurrentPrice(shares: shares) {
            let response = CompanyPortfolioShares.Response(shares: shares)
            self.presenter?.presentShares(response: response)
        }
        //else { return }
//            let purchasePrice = shares?.reduce(0) { $0 + $1.purchasePrice } ?? 0
//            var currentPrice: Double = 0
//            if let shares = shares {
//                currentPrice = getCurrentPrice(shares: shares)
//            }
//
//            let portfolioWithPrices = PortfolioWithPrices(portfolio: portfolio, purchasePrice: String(purchasePrice), priceAndChange: NSMutableAttributedString(string: String(currentPrice), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]))
//            portfoliosWithPrices.append(portfolioWithPrices)
//        }
//        let response = CompanyPortfolioShares.Response(shares: shares)
//        presenter?.presentShares(response: response)
    }
    
    func removeShare(share: Share) {
      //  let portfolioToDelete = portfolioWithPrices.portfolio
     //   dataSourceOfPortfolio?.removePortfolio(portfolio: portfolio)
        
//            _notebooks.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            if _numberOfNotebooks == 0 {
//                setEditing(false, animated: true)
//            }
           // updateEditButtonState()
       // }
    }
    
    func addShare(symbol: String, count: Int64, price: Double, portfolio: Portfolio) {
        dataSourceOfShares?.createShare(name: symbol, count: count, purchasePrice: price, portfolio: portfolio)
        fetchShares(porfolio: portfolio)
       // fetchPortfolios()
        
    }
    
//    func updatePortfolio(portfolio: Portfolio, name: String) {
//        dataSourceOfPortfolio?.updatePortfolio(portfolio: portfolio, name: name)
//
//    }
    
}

extension CompanyPortfolioSharesInteractor {
    func getCurrentPrice(shares: [Share],  completion: @escaping () -> Void)  {
        let userListDispatchGroup = DispatchGroup()

        
        for share in shares {
            guard let symbol = share.symbol else { return }

            userListDispatchGroup.enter()
            worker?.fetchPrice(keyword: symbol) {
                price, error in

                if let price = price {
                    share.currentPrice = price.price
                 //   print(share.currentPrice)
                    
                } else {
                    share.currentPrice = 0
                }
                userListDispatchGroup.leave()
            }
        }
        userListDispatchGroup.notify(queue: .main) {
            completion()
            //  let currentPrice = shares.reduce(0) { $0 + $1.currentPrice * Double($1.count)}
          //  print(currentPrice)
           // self.tableView.reloadData()
        }
        //        let currentPrice = shares.reduce(0) { $0 + $1.currentPrice }
//        return currentPrice
    }
}
