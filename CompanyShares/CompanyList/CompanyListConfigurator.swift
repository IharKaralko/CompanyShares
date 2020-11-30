//
//  CompanyListConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/19/20.
//

import Foundation

class CompanyListConfigurator {
    static let shared = CompanyListConfigurator()
    
    func configure(with view: CompanyListViewController) {
        let viewController = view
        let interactor = CompanyListInteractor()
        let presenter = CompanyListPresenter()
        let worker = CompanyListWorker()
        let router = CompanyListRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
    }
}
