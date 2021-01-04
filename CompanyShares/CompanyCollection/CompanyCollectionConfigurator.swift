//
//  CompanyCollectionConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/3/20.
//

import Foundation

class CompanyCollectionConfigurator {
    static let shared = CompanyCollectionConfigurator()
    
    func configure(with view: CompanyCollectionViewController) {
        let viewController = view
        let interactor = CompanyCollectionInteractor()
        let presenter = CompanyCollectionPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.dataSourceOfSelectedCompany = DataSourceOfSelectedCompany()
        presenter.viewController = viewController
    }
}
