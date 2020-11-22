//
//  CompanyListPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/19/20.
//

import Foundation

protocol CompanyListPresentationLogic {
    func presentPossibleOptions(response: CompanyList.Response)
}

class CompanyListPresenter {
    weak var viewController: CompanyListDisplayLogic?
}

extension CompanyListPresenter: CompanyListPresentationLogic {
    func presentPossibleOptions(response: CompanyList.Response) {
        let viewModel = CompanyList.ViewModel(companies: response.companies)
        viewController?.displayPossibleOptions(viewModel: viewModel)
    }
}
