//
//  AddSharesViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/10/21.
//

import UIKit

protocol AddSharesDisplayLogic: class {
    func displayPrice(viewModel: AddShares.ViewModel)
}

protocol AddSharesViewControllerProtocol: class {
    func addShares(company: Company)
}

class AddSharesViewController: UIViewController {
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var tickerLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    private var currentPrice: Double = 0
    
    var interactor: AddSharesBusinessLogic?
    var portfolio: Portfolio?
    var routerDelegate: CompanyListRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddSharesConfigurator.shared.configure(with: self)
        setLabels()
        setSaveButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) { NotificationCenter.default.removeObserver(self)
    }
}

private extension AddSharesViewController {
    @IBAction func saveAction(_ sender: UIButton) {
        guard let portfolio = portfolio,
              let symbol = symbolLabel.text,
              let amount = Int64(amountTextField.text ?? ""),
              let price = Double(priceTextField.text ?? "") else { return  }
        let newShare = NewShare(symbol: symbol, amount: amount, purchasePrice: price, currentPrice: currentPrice, portfolio: portfolio)
        let request = AddShares.Requst(newShare: newShare)
        interactor?.addShare(request: request)
        routerDelegate?.popVC()
    }
    
    func setLabels() {
        infoLabel.text = "AddShares_Enter_new_shares_details".localized
        tickerLabel.text = "AddShares_Ticker".localized
        amountLabel.text = "AddShares_Amount".localized
        priceLabel.text = "AddShares_Price".localized
    }
    
    func setSaveButton() {
        saveButton.layer.cornerRadius = 10
        saveButton.setTitle("AddShares_Save".localized, for: .normal)
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) { [weak self] notif in
            if let amount = Int(self?.amountTextField.text ?? ""), amount > 0, let price = Double(self?.priceTextField.text ?? ""), price > 0, let symbol = self?.symbolLabel.text, !symbol.isEmpty {
                self?.saveButton.isEnabled = true
            } else {
                self?.saveButton.isEnabled = false
            }
        }
    }
}

// MARK: - AddSharesViewControllerProtocol
extension AddSharesViewController: AddSharesViewControllerProtocol {
    func addShares(company: Company) {
        symbolLabel.text = company.symbol
        interactor?.loadPrice(symbol: company.symbol)
    }
}

// MARK: - AddSharesDisplayLogic
extension AddSharesViewController: AddSharesDisplayLogic {
    func displayPrice(viewModel: AddShares.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.priceTextField.text = viewModel.price
            self?.currentPrice = Double(viewModel.price) ?? 0
        }
    }
}
