//
//  CompanyDetailsViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/25/20.
//

import UIKit

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
    }
}

private extension CompanyDetailsViewController {
    func showDetails() {
        guard let company = company else { return }
        let request = CompanyDetails.Requst(company: company)
        interactor?.fetchDetail(request: request)
    }
}

extension CompanyDetailsViewController: CompanyDetailsDisplayLogic {
    func displayNoData(viewModel: CompanyDetails.ViewModel) {
        DispatchQueue.main.async {
            self.nameLabel.text = viewModel.name
            self.priceAndChangeLabel.text = NSLocalizedString("No data available", comment: "")
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
