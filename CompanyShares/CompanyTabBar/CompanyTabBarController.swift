//
//  CompanyTabBarController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/8/20.
//

import UIKit

class CompanyTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}

private extension CompanyTabBarController {
    func setupTabBar() {
        let companyList = CompanyListViewController()
        let companyDetails = CompanyDetailsViewController()
        let portfolioList = PortfolioListViewController()
        
        let navControllerInterest = UINavigationController(rootViewController: companyList)
        navControllerInterest.tabBarItem = UITabBarItem(title: "Interests", image: UIImage(named: "interests"), selectedImage: nil )
        
        let navControllerPortfolios = UINavigationController(rootViewController: portfolioList)
        navControllerPortfolios.tabBarItem = UITabBarItem(title: "Portfolios", image: UIImage(named: "portfolio"), selectedImage: nil )
        
        let navControllerSettings = UINavigationController(rootViewController: companyDetails)
        navControllerSettings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "setting"), selectedImage: nil )
        
        viewControllers = [navControllerInterest, navControllerPortfolios, navControllerSettings]
        tabBar.barTintColor = .red
        tabBar.tintColor = .black
    }
}
