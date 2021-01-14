//
//  AddSharesConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

class AddSharesConfigurator {
    static let shared = AddSharesConfigurator()
    
    func configure(with view: AddSharesViewController) {
        let viewController = view
        let interactor = AddSharesInteractor()
        let presenter = AddSharesPresenter()
        let worker = CompanyDetailsWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.dataSourceOfShares = DataSourceOfShare()
        presenter.viewController = viewController
    }
}
