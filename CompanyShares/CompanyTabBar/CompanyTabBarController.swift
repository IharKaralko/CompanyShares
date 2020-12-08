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
        let companyShare = CompanyListViewController()
        let company = CompanyDetailsViewController()
        let navController = UINavigationController(rootViewController: companyShare)
        navController.tabBarItem = UITabBarItem(title: "Interests", image: UIImage(named: "interests"), selectedImage: nil )
        
        let navControllerOne = UINavigationController(rootViewController: company)
        navControllerOne.tabBarItem = UITabBarItem(title: "Portfolios", image: UIImage(named: "portfolio"), selectedImage: nil )
        
        let navControllerTwo = UINavigationController(rootViewController: company)
        navControllerTwo.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "setting"), selectedImage: nil )
        
        viewControllers = [navController, navControllerOne, navControllerTwo]
        tabBar.barTintColor = .red
        tabBar.tintColor = .black
    }
}
