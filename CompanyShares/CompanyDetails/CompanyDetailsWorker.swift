//
//  CompanyDetailsWorker.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

protocol CompanyDetailsWorkingLogic: class {
    func fetchDetails(keyword: String, completion: @escaping (Details?, Error?) -> Void)
    func getCurrentPrice(shares: [Share],  completion: @escaping () -> Void)
}

class CompanyDetailsWorker {
    var dataSourceOfShare: DataSourceOfShareProtocol?
}

extension CompanyDetailsWorker: CompanyDetailsWorkingLogic {
    func fetchDetails(keyword: String, completion: @escaping (Details?, Error?) -> Void) {
        guard let url = Client.Endpoints.getDetails.getURL(keyword: keyword) else { return }
        Client.fetchDetails(url: url) {
            (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getCurrentPrice(shares: [Share],  completion: @escaping () -> Void) {
        let userListDispatchGroup = DispatchGroup()
        var shareCollection = [String:Double]()
        var previousSymbol = ""
        for share in shares {
            guard let symbol = share.symbol, let date = share.date else { return }
            if Date().timeIntervalSince(date) > 100 {
                if  symbol == previousSymbol {
                    continue
                } else {
                    previousSymbol = symbol
                    userListDispatchGroup.enter()
                    fetchDetails(keyword: symbol) { details, error in
                        if let details = details {
                            shareCollection[symbol] = Double(details.price) ?? 0
                        }
                        userListDispatchGroup.leave()
                    }
                }
            }
        }
        userListDispatchGroup.notify(queue: .main) { [weak self] in
            self?.setCurrentPriceForShares(shares, shareCollection: shareCollection)
            completion()
        }
    }
    
    func setCurrentPriceForShares(_ shares: [Share], shareCollection:  [String:Double]) {
        for share in shares {
            for key in shareCollection.keys {
                if share.symbol == key {
                    share.currentPrice = shareCollection[key] ?? 0
                    dataSourceOfShare?.update(share: share, currentPrice: share.currentPrice, amount: nil)
                }
            }
        }
    }
}
