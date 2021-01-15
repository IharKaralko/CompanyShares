//
//  AddSharesInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

protocol AddSharesBusinessLogic: class {
    func loadPrice(symbol: String)
    func addShare(request: AddShares.Requst)
}

class AddSharesInteractor {
    var presenter: AddSharesPresentationLogic?
    var worker: CompanyDetailsWorkingLogic?
    var dataSourceOfShare: DataSourceOfShareProtocol?
}

// MARK: - AddSharesBusinessLogic
extension AddSharesInteractor: AddSharesBusinessLogic {
    func addShare(request: AddShares.Requst) {
        dataSourceOfShare?.createShare(request.newShare)
    }
    
    func loadPrice(symbol: String) {
        worker?.fetchDetails(keyword: symbol) { [weak self] details, error in
            let response: AddShares.Response
            if let details = details {
                response = AddShares.Response(price: details.price)
                self?.presenter?.presentPrice(response: response)
            } else {
                response =  AddShares.Response(price: "AddShares_Not_available".localized)
                self?.presenter?.presentPrice(response: response)
            }
        }
    }
}
