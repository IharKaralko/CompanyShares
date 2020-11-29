//
//  CompanyDetailsViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/25/20.
//

import UIKit

protocol CompanyDetailsDisplayLogic: class {
    func displayDetails(viewModel: CompanyDetails.ViewModel)
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
    var symbol: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CompanyDetailsConfigurator.shared.configure(with: self)
        showDetails()
    }
}

extension CompanyDetailsViewController {
    func showDetails() {
        guard let symbol = symbol else { return }
        let request = CompanyDetails.Requst(symbol: symbol)
        interactor?.fetchDetail(request: request)
    }
}

extension CompanyDetailsViewController: CompanyDetailsDisplayLogic {
    func displayDetails(viewModel: CompanyDetails.ViewModel) {
        DispatchQueue.main.async {[weak self] in
            self?.nameLabel.text = viewModel.companyResult.name
            self?.priceAndChangeLabel.attributedText = viewModel.companyResult.priceAndChange
            self?.openLabel.text = viewModel.companyResult.open
            self?.previosCloseLabel.text = viewModel.companyResult.previosClose
            self?.highLabel.text = viewModel.companyResult.high
            self?.lowLabel.text = viewModel.companyResult.low
            self?.volumeLabel.text = viewModel.companyResult.volume
        }
    }
}
