//
//  CompanyPortfolioListPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation

protocol CompanyPortfolioListPresentationLogic {
    func presentPortfolios(response: CompanyPortfolioList.Response)
}

class CompanyPortfolioListPresenter {
    weak var viewController: CompanyPortfolioListDisplayLogic?
}

// MARK: - CompanyPortfolioListPresentationLogic
extension CompanyPortfolioListPresenter: CompanyPortfolioListPresentationLogic {
    func presentPortfolios(response: CompanyPortfolioList.Response) {
        let viewModel = CompanyPortfolioList.ViewModel(portfoliosWithPrice: response.portfoliosWithPrice)
        viewController?.displayPortfolioList(viewModel: viewModel)
    }
}
