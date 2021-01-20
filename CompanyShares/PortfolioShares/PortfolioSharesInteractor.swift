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
        worker?.getCurrentPrice(shares: shares) {
            let response = PortfolioShares.Response(shares: shares)
            self.presenter?.presentShares(response: response)
        }
    }
    
    func remove(share: Share) {
        dataSourceOfShare?.remove(share: share)
    }
}
