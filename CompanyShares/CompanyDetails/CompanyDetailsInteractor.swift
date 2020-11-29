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
        worker?.fetchDetails(keyword: request.symbol) { details, error in
            if let details = details {
                let response = CompanyDetails.Response(companyResult: CompanyResult(name: request.symbol, priceAndChange: self.getAttributedString(details: details), open: details.open, previosClose: details.previosClose, high: details.high, low: details.low, volume: details.volume))
                self.presenter?.presentDetails(response: response)
                
            }
          //  let response = CompanyDetails.Response(companyResult: details)
        //   self.presenter?.presentDetails(response: response)
        }
    }
}
extension CompanyDetailsInteractor {
    func getAttributedString(details: Details) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: details.price, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        
        var attrs: [NSAttributedString.Key : Any]
        
        if details.change.first == "-" {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.red]
        }
        else {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.green]
        }
        
        let change = " " + details.change + " (" + details.changePercent + ")"
        
        let attributedChange = NSMutableAttributedString(string: change, attributes: attrs)
        attributedString.append(attributedChange)
        
        return attributedString
    }
}
