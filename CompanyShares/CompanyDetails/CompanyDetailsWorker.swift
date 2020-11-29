//
//  CompanyDetailsWorker.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

protocol CompanyDetailsWorkingLogic: class {
    func fetchDetails(keyword: String, completion: @escaping (Details?, Error?) -> Void)
}

class CompanyDetailsWorker: CompanyDetailsWorkingLogic {
    func fetchDetails(keyword: String, completion: @escaping (Details?, Error?) -> Void) {
        guard let url = Client.Endpoints.getDetails.getURL(keyword: keyword) else { return }
        Client.fetchDetails(url: url) {
            (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
