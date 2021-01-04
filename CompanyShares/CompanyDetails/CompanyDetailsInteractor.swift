//
//  CompanyDetailsInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

protocol CompanyDetailsBusinessLogic: class {
    func fetchDetail(request: CompanyDetails.Requst)
    func remove(selectedCompany: SelectedCompany)
}

class CompanyDetailsInteractor {
    var presenter: CompanyDetailsPresentationLogic?
    var worker: CompanyDetailsWorkingLogic?
    var dataSourceOfSelectedCompany: DataSourceOfSelectedCompanyProtocol?
}

// MARK: - CompanyDetailsBusinessLogic
extension CompanyDetailsInteractor: CompanyDetailsBusinessLogic {
    func fetchDetail(request: CompanyDetails.Requst) {
        worker?.fetchDetails(keyword: request.company.symbol ?? "") { [weak self] details, error in
            let response: CompanyDetails.Response
            if let details = details {
                response = CompanyDetails.Response(company: request.company, details: details)
                self?.presenter?.presentDetails(response: response)
            } else {
                response = CompanyDetails.Response(company: request.company, details: nil)
                self?.presenter?.presentNoData(response: response)
            }
        }
    }
    
    func remove(selectedCompany: SelectedCompany) {
        dataSourceOfSelectedCompany?.remove(selectedCompany: selectedCompany)
    }
}
