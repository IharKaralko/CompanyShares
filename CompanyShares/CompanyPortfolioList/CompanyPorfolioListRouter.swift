//
//  CompanyPorfolioListRouter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import UIKit

protocol CompanyPortfolioListRoutingLogic: class {
    func routeToPortfolioDetails(portfolio: Portfolio, navVC: UINavigationController)
}

class CompanyPorfolioListRouter: CompanyPortfolioListRoutingLogic {
    func routeToPortfolioDetails(portfolio: Portfolio, navVC: UINavigationController) {
        let portfolioSharesVC = CompanyPortfolioSharesViewController()
        portfolioSharesVC.portfolio = portfolio
        navVC.pushViewController(portfolioSharesVC, animated: true)
    }
}
