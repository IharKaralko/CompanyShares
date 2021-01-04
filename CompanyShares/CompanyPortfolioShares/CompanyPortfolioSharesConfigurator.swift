//
//  CompanyPortfolioSharesConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import Foundation

class CompanyPortfolioSharesConfigurator {
    static let shared = CompanyPortfolioSharesConfigurator()
    
    func configure(with view: CompanyPortfolioSharesViewController) {
        let viewController = view
        let interactor = CompanyPortfolioSharesInteractor()
        let presenter = CompanyPortfolioSharesPresenter()
        let worker = CompanyPortfolioListWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.dataSourceOfShares = DataSourceOfShare()
        presenter.viewController = viewController
    }
}
