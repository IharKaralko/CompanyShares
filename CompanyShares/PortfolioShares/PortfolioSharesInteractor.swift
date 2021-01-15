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
}

class PortfolioSharesInteractor {
    var presenter: PortfolioSharesPresentationLogic?
    var worker: CompanyDetailsWorkingLogic?
    var dataSourceOfShare: DataSourceOfShareProtocol?
}

// MARK: - PortfolioSharesBusinessLogic
extension PortfolioSharesInteractor: PortfolioSharesBusinessLogic {
    func fetchShares(porfolio: Portfolio) {
        guard let shares = dataSourceOfShare?.getShares(portfolio: porfolio) else { return }
        getCurrentPrice(shares: shares) {
            let response = PortfolioShares.Response(shares: shares)
            self.presenter?.presentShares(response: response)
        }
    }
    
    func remove(share: Share) {
        dataSourceOfShare?.remove(share: share)
    }
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
                        self?.dataSourceOfShare?.update(share: share, currentPrice: share.currentPrice, date: Date())
                    }
                    userListDispatchGroup.leave()
                }
            }
        }
        userListDispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
