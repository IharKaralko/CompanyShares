//
//  CompanyDetailsPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import Foundation

protocol CompanyDetailsPresentationLogic: class {
    func presentDetails(response: CompanyDetails.Response)
    func presentNoData(response: CompanyDetails.Response)
}

class CompanyDetailsPresenter {
    weak var viewController: CompanyDetailsDisplayLogic?
}

extension CompanyDetailsPresenter: CompanyDetailsPresentationLogic {
    func presentNoData(response: CompanyDetails.Response) {
        let viewModel = CompanyDetails.ViewModel(name: response.name, companyResult: response.companyResult)
        viewController?.displayNoData(viewModel: viewModel)
    }
    
    func presentDetails(response: CompanyDetails.Response) {
        guard let companyResult = response.companyResult else { return }
        let open = NSLocalizedString("Open:", comment: "") + "  " + companyResult.open
        let previosClose = NSLocalizedString("Previos close:", comment: "") + "  " + companyResult.previosClose
        let high = NSLocalizedString("High:", comment: "") + "  " + companyResult.high
        let low = NSLocalizedString("Low:", comment: "") + "  " + companyResult.low
        let volume = NSLocalizedString("Volume:", comment: "") + "  " + companyResult.volume
        
        let viewModel = CompanyDetails.ViewModel(name: response.name, companyResult: CompanyResult(priceAndChange: companyResult.priceAndChange, open: open, previosClose: previosClose, high: high, low: low, volume: volume))
        viewController?.displayDetails(viewModel: viewModel)
    }
}
