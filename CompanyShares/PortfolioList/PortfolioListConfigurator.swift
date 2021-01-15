//
//  PortfolioListConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation

class PortfolioListConfigurator {
    static let shared = PortfolioListConfigurator()
    
    func configure(with view: PortfolioListViewController) {
        let viewController = view
        let interactor = PortfolioListInteractor()
        let presenter = PortfolioListPresenter()
        let worker = CompanyDetailsWorker()
        let router = PorfolioListRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.dataSourceOfPortfolio = DataSourceOfPortfolio()
        interactor.dataSourceOfShare = DataSourceOfShare()
        presenter.viewController = viewController
    }
}
