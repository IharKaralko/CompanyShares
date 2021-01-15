//
//  CompanyDetailsPresenter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import UIKit

protocol CompanyDetailsPresentationLogic: class {
    func presentDetails(response: CompanyDetails.Response)
    func presentNoData(response: CompanyDetails.Response)
}

class CompanyDetailsPresenter {
    weak var viewController: CompanyDetailsDisplayLogic?
}

// MARK: - CompanyDetailsPresentationLogic
extension CompanyDetailsPresenter: CompanyDetailsPresentationLogic {
    func presentNoData(response: CompanyDetails.Response) {
        let name = getNameAndSymbol(response.company)
        let viewModel = CompanyDetails.ViewModel(name: name, companyResult: nil)
        viewController?.displayNoData(viewModel: viewModel)
    }
    
    func presentDetails(response: CompanyDetails.Response) {
        let name = getNameAndSymbol(response.company)
        guard let details = response.details else { return }
        let price = getAttributedString(details: details)
        let open = "CompanyDetails_Open:".localized + "  " + details.open
        let previosClose = "CompanyDetails_Previos_close:".localized + "  " + details.previosClose
        let high = "CompanyDetails_High:".localized + "  " + details.high
        let low = "CompanyDetails_Low:".localized + "  " + details.low
        let volume = "CompanyDetails_Volume:".localized + "  " + details.volume
        
        let viewModel = CompanyDetails.ViewModel(name: name, companyResult: CompanyResult(priceAndChange: price, open: open, previosClose: previosClose, high: high, low: low, volume: volume))
        viewController?.displayDetails(viewModel: viewModel)
    }
}

private extension CompanyDetailsPresenter {
    func getNameAndSymbol(_ company: SelectedCompany) -> String {
        guard let name = company.name, let symbol = company.symbol else { return ""}
        let nameAndSymbol = name + " (" + symbol + ")"
        return nameAndSymbol
    }
    
    func getAttributedString(details: Details) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: details.price, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        var attrs: [NSAttributedString.Key : Any]
        if details.change.first == "-" {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.red]
        }
        else {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        }
        let change = "  " + details.change + " (" + details.changePercent + ")"
        let attributedChange = NSMutableAttributedString(string: change, attributes: attrs)
        attributedString.append(attributedChange)
        return attributedString
    }
}
