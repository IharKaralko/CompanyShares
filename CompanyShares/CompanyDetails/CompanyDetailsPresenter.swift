//
//  CompanyDetailsPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

protocol CompanyDetailsPresentationLogic: class {
    func presentDetails(response: CompanyDetails.Response)
}

class CompanyDetailsPresenter {
    weak var viewController: CompanyDetailsDisplayLogic?
}

extension CompanyDetailsPresenter: CompanyDetailsPresentationLogic {
    func presentDetails(response: CompanyDetails.Response) {
        let viewModel = CompanyDetails.ViewModel(companyResult: response.companyResult)
        viewController?.displayDetails(viewModel: viewModel)
    }
}
