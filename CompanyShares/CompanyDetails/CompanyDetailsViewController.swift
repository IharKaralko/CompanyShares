//
//  CompanyDetailsViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/25/20.
//

import UIKit
import RealmSwift

protocol CompanyDetailsDisplayLogic: class {
    func displayDetails(viewModel: CompanyDetails.ViewModel)
    func displayNoData(viewModel: CompanyDetails.ViewModel)
}

class CompanyDetailsViewController: UIViewController {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceAndChangeLabel: UILabel!
    @IBOutlet private weak var openLabel: UILabel!
    @IBOutlet private weak var previosCloseLabel: UILabel!
    @IBOutlet private weak var highLabel: UILabel!
    @IBOutlet private weak var lowLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!
    
    var interactor: CompanyDetailsBusinessLogic?
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CompanyDetailsConfigurator.shared.configure(with: self)
        showDetails()
        navigationBarSetting()
    }
}

private extension CompanyDetailsViewController {
    func navigationBarSetting() {
        navigationItem.title = "Details".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete".localized, style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc
    func addTapped() {
        guard let company = self.company else { return }
        
        let alertController = UIAlertController(title: "Attention!".localized, message: "Remove company?".localized, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK".localized, style: .default) {[weak self] action in
            self?.interactor?.removeCompany(company: company)
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showDetails() {
        guard let company = self.company else { return }
        let request = CompanyDetails.Requst(company: company)
        self.interactor?.fetchDetail(request: request)
    }
}

// MARK: - CompanyDetailsDisplayLogic
extension CompanyDetailsViewController: CompanyDetailsDisplayLogic {
    func displayNoData(viewModel: CompanyDetails.ViewModel) {
        DispatchQueue.main.async {
            self.nameLabel.text = viewModel.name
            self.priceAndChangeLabel.text = "No data available".localized
        }
    }
    
    func displayDetails(viewModel: CompanyDetails.ViewModel) {
        DispatchQueue.main.async {
            guard let companyResult = viewModel.companyResult else { return }
            self.nameLabel.text = viewModel.name
            self.priceAndChangeLabel.attributedText = companyResult.priceAndChange
            self.openLabel.text = companyResult.open
            self.previosCloseLabel.text = companyResult.previosClose
            self.highLabel.text = companyResult.high
            self.lowLabel.text = companyResult.low
            self.volumeLabel.text = companyResult.volume
        }
    }
}
