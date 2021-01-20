//
//  BuyAndSellSharesConfigurator.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

class BuyAndSellSharesConfigurator {
    static let shared = BuyAndSellSharesConfigurator()
    
    func configure(with view: BuyAndSellSharesViewController) {
        let viewController = view
        let interactor = BuyAndSellSharesInteractor()
        let presenter = BuyAndSellSharesPresenter()
        let worker = CompanyDetailsWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.dataSourceOfShare = DataSourceOfShare()
        presenter.viewController = viewController
    }
}
