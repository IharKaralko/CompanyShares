//
//  PorfolioListRouter.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import UIKit

protocol PortfolioListRoutingLogic: class {
    func routeToPortfolioDetails(portfolio: Portfolio, navVC: UINavigationController)
}

class PorfolioListRouter: PortfolioListRoutingLogic {
    func routeToPortfolioDetails(portfolio: Portfolio, navVC: UINavigationController) {
        let portfolioSharesVC = PortfolioSharesViewController()
        portfolioSharesVC.portfolio = portfolio
        navVC.pushViewController(portfolioSharesVC, animated: true)
    }
}
