//
//  CompanyListInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/19/20.
//

import Foundation

protocol CompanyListBusinessLogic: class {
    func fetchPossibleOptions(request: CompanyList.Requst)
}

class CompanyListInteractor {
    var presenter: CompanyListPresentationLogic?
    var worker: CompanyListWorkingLogic?
}

// MARK: - CompanyListBusinessLogic
extension CompanyListInteractor: CompanyListBusinessLogic {
    func fetchPossibleOptions(request: CompanyList.Requst) {
        worker?.fetchCompanies(keyword: request.keyword) { companies, error in
            var items = [Company]()
            if let companies = companies {
                items = companies
            }
            let response = CompanyList.Response(companies: items)
            self.presenter?.presentPossibleOptions(response: response)
        }
    }
}
