//
//  CompanyCollectionInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/3/20.
//

import Foundation

protocol CompanyCollectionBusinessLogic: class {
    func loadCompanyList()
    func add(company: Company)
    func remove(selectedCompany: SelectedCompany)
}

class CompanyCollectionInteractor {
    var presenter: CompanyCollectionPresentationLogic?
    var dataSourceOfSelectedCompany: DataSourceOfSelectedCompanyProtocol?
}

// MARK: - CompanyCollectionBusinessLogic
extension CompanyCollectionInteractor: CompanyCollectionBusinessLogic {
    func add(company: Company) {
        dataSourceOfSelectedCompany?.create(company: company)
        loadCompanyList()
    }
    
    func remove(selectedCompany: SelectedCompany) {
        dataSourceOfSelectedCompany?.remove(selectedCompany: selectedCompany)
        loadCompanyList()
    }
    
    func loadCompanyList() {
        guard let companies = dataSourceOfSelectedCompany?.getSelectedCompanies() else { return }
        let responce = CompanyCollection.Response(companies: companies)
        presenter?.presentCompanyList(response: responce)
    }
}
