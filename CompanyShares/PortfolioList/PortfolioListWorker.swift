//
//  PortfolioListWorker.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation

protocol PortfolioListWorkingLogic: class {
    func fetchPrice(keyword: String, completion: @escaping (Price?, Error?) -> Void)
}

class PortfolioListWorker: PortfolioListWorkingLogic {
    func fetchPrice(keyword: String, completion: @escaping (Price?, Error?) -> Void) {
        guard let url = Client.Endpoints.getPrice.getURL(keyword: keyword) else { return }
        Client.getPrice(url: url) {
            (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
