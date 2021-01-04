//
//  CompanyListRouter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/19/20.
//

import UIKit

protocol CompanyListRoutingLogic: class {
    func routeToCopmanyDetails(company: SelectedCompany, navVC: UINavigationController)
}

class CompanyListRouter: CompanyListRoutingLogic {
    func routeToCopmanyDetails(company: SelectedCompany, navVC: UINavigationController) {
        let companyDetailsVC = CompanyDetailsViewController()
        companyDetailsVC.company = company
        navVC.pushViewController(companyDetailsVC, animated: true)
    }
}
