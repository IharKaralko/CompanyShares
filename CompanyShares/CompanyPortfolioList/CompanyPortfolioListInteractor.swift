//
//  CompanyPortfolioListInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import UIKit

protocol CompanyPortfolioListBusinessLogic: class {
    func fetchPortfolios()
    func removePortfolios(portfolio: Portfolio)
    func addPortfolio(name: String)
    func updatePortfolio(portfolio: Portfolio, name: String)
}

class CompanyPortfolioListInteractor {
    var presenter: CompanyPortfolioListPresentationLogic?
    var worker: CompanyPortfolioListWorkingLogic?
    
    var dataSourceOfPortfolio: DataSourceOfPortfolioProtocol?
    var dataSourceOfShares: DataSourceOfShare?
    
}

// MARK: - CompanyPortfolioListBusinessLogic
extension CompanyPortfolioListInteractor: CompanyPortfolioListBusinessLogic {
    func fetchPortfolios() {
        var portfoliosWithPrices = [PortfolioWithPrices]()
        guard let portfolios = dataSourceOfPortfolio?.getPortfolios() else { return }
        
        let userListDispatchGroup = DispatchGroup()
        
        for portfolio in portfolios {
            let shares = dataSourceOfShares?.getShares(portfolio: portfolio) //else { return }
            let purchasePrice = shares?.reduce(0) { $0 + $1.purchasePrice * Double($1.count)} ?? 0
            var currentPrice: Double = 0
            if let shares = shares {
                userListDispatchGroup.enter()
                
                getCurrentPrice(shares: shares){ current in
                currentPrice = current
                print(current)
       //     }
     //       }
                let priceAndChange = self.getAttributedString(purchasePrice: purchasePrice, currentPrice: currentPrice)
                let purchasePriceFormat = String(format: "%.2f", purchasePrice)
                let portfolioWithPrices = PortfolioWithPrices(portfolio: portfolio, purchasePrice: purchasePriceFormat, priceAndChange: priceAndChange)
            portfoliosWithPrices.append(portfolioWithPrices)
                    userListDispatchGroup.leave()
                    
//                    let response = CompanyPortfolioList.Response(portfoliosWithPrice: portfoliosWithPrices)
//                self.presenter?.presentPortfolios(response: response)
                
            }
        }
        }
        userListDispatchGroup.notify(queue: .main) {
                    let response = CompanyPortfolioList.Response(portfoliosWithPrice: portfoliosWithPrices)
                    self.presenter?.presentPortfolios(response: response)
            
        }

//        let response = CompanyPortfolioList.Response(portfoliosWithPrice: portfoliosWithPrices)
//        self.presenter?.presentPortfolios(response: response)
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
    
    func removePortfolios(portfolio: Portfolio) {
      //  let portfolioToDelete = portfolioWithPrices.portfolio
        dataSourceOfPortfolio?.removePortfolio(portfolio: portfolio)
        
//            _notebooks.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            if _numberOfNotebooks == 0 {
//                setEditing(false, animated: true)
//            }
           // updateEditButtonState()
       // }
    }
    
    func addPortfolio(name: String) {
        dataSourceOfPortfolio?.createPortfolio(name: name)
        fetchPortfolios()
    }
    
    func updatePortfolio(portfolio: Portfolio, name: String) {
        dataSourceOfPortfolio?.updatePortfolio(portfolio: portfolio, name: name)
    }
}
extension CompanyPortfolioListInteractor {
    func getCurrentPrice(shares: [Share], completion: @escaping (Double) -> Void)  {
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
            let currentPrice = shares.reduce(0) { $0 + $1.currentPrice * Double($1.count)}
          //  print(currentPrice)
            completion(currentPrice)
           // self.tableView.reloadData()
        }
        //        let currentPrice = shares.reduce(0) { $0 + $1.currentPrice }
//        return currentPrice
    }
}
