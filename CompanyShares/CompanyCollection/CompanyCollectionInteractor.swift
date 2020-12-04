//
//  CompanyCollectionInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/3/20.
//

import Foundation
import RealmSwift

protocol CompanyCollectionBusinessLogic: class {
    func loadCompanyList()
    func setObserver()
    func addCompany(company: Company)
    func removeCompany(company: Company)
    
}

class CompanyCollectionInteractor {
    var presenter: CompanyCollectionPresentationLogic?
    var token: NotificationToken!
    
    deinit {
        token.invalidate()
    }
}

// MARK: - CompanyCollectionBusinessLogic
extension CompanyCollectionInteractor: CompanyCollectionBusinessLogic {
    func addCompany(company: Company) {
        StorageManager.saveCompany(company)
    }
    
    func removeCompany(company: Company) {
        StorageManager.removeCompany(company)
    }
    
    func loadCompanyList() {
        let companies = StorageManager.realm?.objects(Company.self)
        let responce = CompanyCollection.Response(companies: companies)
        presenter?.presentCompanyList(response: responce)
    }
    
    func setObserver() {
        token = StorageManager.realm?.observe { [weak self] notification, realm in
            self?.presenter?.reloadCompanyList()
        }
    }
}
