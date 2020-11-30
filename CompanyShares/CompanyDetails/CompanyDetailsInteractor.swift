//
//  CompanyDetailsInteractor.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/26/20.
//

import UIKit

protocol CompanyDetailsBusinessLogic: class {
    func fetchDetail(request: CompanyDetails.Requst)
}

class CompanyDetailsInteractor {
    var presenter: CompanyDetailsPresentationLogic?
    var worker: CompanyDetailsWorkingLogic?
    
}

extension CompanyDetailsInteractor: CompanyDetailsBusinessLogic {
    func fetchDetail(request: CompanyDetails.Requst) {
        worker?.fetchDetails(keyword: request.company.symbol) { [weak self] details, error in
            guard let name = self?.getNameAndSymbol(request.company) else { return }
            let response: CompanyDetails.Response
            if let details = details {
                guard let price = self?.getAttributedString(details: details) else { return }
                let companyResult = CompanyResult(priceAndChange: price, open: details.open, previosClose: details.previosClose, high: details.high, low: details.low, volume: details.volume)
                response = CompanyDetails.Response(name: name, companyResult: companyResult)
               self?.presenter?.presentDetails(response: response)
            } else {
                response = CompanyDetails.Response(name: name, companyResult: nil)
                self?.presenter?.presentNoData(response: response)
            }
        }
    }
}

private extension CompanyDetailsInteractor {
    func getNameAndSymbol(_ company: Company) -> String {
        let nameAndSymbol = company.name + " (" + company.symbol + ")"
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
