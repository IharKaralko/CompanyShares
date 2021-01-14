//
//  PortfolioSharesConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import Foundation

class PortfolioSharesConfigurator {
    static let shared = PortfolioSharesConfigurator()
    
    func configure(with view: PortfolioSharesViewController) {
        let viewController = view
        let interactor = PortfolioSharesInteractor()
        let presenter = PortfolioSharesPresenter()
        let worker = CompanyDetailsWorker() 
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.dataSourceOfShares = DataSourceOfShare()
        presenter.viewController = viewController
    }
}
