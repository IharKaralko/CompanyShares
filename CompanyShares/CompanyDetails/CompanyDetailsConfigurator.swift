//
//  CompanyDetailsConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

class CompanyDetailsConfigurator {
    static let shared = CompanyDetailsConfigurator()
    
    func configure(with view: CompanyDetailsViewController) {
        let viewController = view
        let interactor = CompanyDetailsInteractor()
        let presenter = CompanyDetailsPresenter()
        let worker = CompanyDetailsWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.dataSourceOfSelectedCompany = DataSourceOfSelectedCompany()
        presenter.viewController = viewController
    }
}
