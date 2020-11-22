//
//  CompanyListWorker.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/19/20.
//

import Foundation

protocol CompanyListWorkingLogic: class {
    func fetchCompanies(keyword: String, completion: @escaping ([Company]?, Error?) -> Void)
}

class CompanyListWorker: CompanyListWorkingLogic {
    func fetchCompanies(keyword: String, completion: @escaping ([Company]?, Error?) -> Void) {
        guard let url = Client.Endpoints.searchCompany.getURL(keyword: keyword) else { return }
        Client.fetchCompanies(url: url) {
            (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
