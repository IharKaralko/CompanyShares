//
//  CompanyPortfolioListConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation

class CompanyPortfolioListConfigurator {
    static let shared = CompanyPortfolioListConfigurator()
    
    func configure(with view: CompanyPortfolioListViewController) {
        let viewController = view
        let interactor = CompanyPortfolioListInteractor()
        let presenter = CompanyPortfolioListPresenter()
        let worker = CompanyPortfolioListWorker()
        let router = CompanyPorfolioListRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.dataSourceOfPortfolio = DataSourceOfPortfolio()
        interactor.dataSourceOfShares = DataSourceOfShare()
        presenter.viewController = viewController
    }
}
