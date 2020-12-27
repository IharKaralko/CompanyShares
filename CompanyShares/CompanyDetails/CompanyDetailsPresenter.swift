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
        let open = "Open:".localized + "  " + companyResult.open
        let previosClose = "Previos close:".localized + "  " + companyResult.previosClose
        let high = "High:".localized + "  " + companyResult.high
        let low = "Low:".localized + "  " + companyResult.low
        let volume = "Volume:".localized + "  " + companyResult.volume
        
        let viewModel = CompanyDetails.ViewModel(name: response.name, companyResult: CompanyResult(priceAndChange: companyResult.priceAndChange, open: open, previosClose: previosClose, high: high, low: low, volume: volume))
        viewController?.displayDetails(viewModel: viewModel)
    }
}
