//
//  AddSharesPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

protocol AddSharesPresentationLogic {
    func presentPrice(response: AddShares.Response)
}

class AddSharesPresenter {
    weak var viewController: AddSharesDisplayLogic?
}

// MARK: - CompanyCollectionPresentationLogic
extension AddSharesPresenter: AddSharesPresentationLogic {
    func presentPrice(response: AddShares.Response) {
        let viewModel = AddShares.ViewModel(price: response.price)
        viewController?.displayPrice(viewModel:viewModel)
    }
}
