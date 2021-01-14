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
  //  var routerDelegate: CompanyListRouterProtocol? { set get }
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
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let portfolio = portfolio,
        let symbol = symbolLabel.text,
        let amount = Int64(amountTextField.text ?? ""),
        let price = Double(priceTextField.text ?? "") else { return  }
        interactor?.addShare(symbol: symbol, count: amount, price: price, portfolio: portfolio)
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.routerDelegate?.popVC()
        }
      //  routerDelegate?.popVC()
        
    }
}



extension AddSharesViewController {
    func setLabels() {
        infoLabel.text = "Enter new shares details".localized
        tickerLabel.text = "Ticker".localized
        amountLabel.text = "Amount".localized
        priceLabel.text = "Price".localized
    }
    
    func setSaveButton() {
        saveButton.layer.cornerRadius = 10
        
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
        DispatchQueue.main.async {self.priceTextField.text = viewModel.price}
    }
}
