//
//  CompanyCollectionPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/3/20.
//

import Foundation

protocol CompanyCollectionPresentationLogic {
    func presentCompanyList(response: CompanyCollection.Response)
    func reloadCompanyList()
}

class CompanyCollectionPresenter {
    weak var viewController: CompanyCollectionDisplayLogic?
}

// MARK: - CompanyCollectionPresentationLogic
extension CompanyCollectionPresenter: CompanyCollectionPresentationLogic {
    func presentCompanyList(response: CompanyCollection.Response) {
        let viewModel = CompanyCollection.ViewModel(companies: response.companies)
        viewController?.displayCompany(viewModel: viewModel)
    }
    
    func reloadCompanyList() {
        viewController?.reloadCompaniesList()
    }
}
