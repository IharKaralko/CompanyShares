//
//  AddSharesViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/10/21.
//

import UIKit

protocol AddSharesViewControllerProtocol: class {
  //  var routerDelegate: CompanyListRouterProtocol? { set get }
    func addShares(company: Company)
}

class AddSharesViewController: UIViewController {
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfoLabel()
        setTextFields()
        setSaveButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) { NotificationCenter.default.removeObserver(self)
    }
}

extension AddSharesViewController {
    func setInfoLabel() {
        infoLabel.text = "Enter new shares details".localized
    }
    
    func setTextFields() {
        amountTextField.placeholder = "Amount".localized
        priceTextField.placeholder = "Price".localized
    }
    
    func setSaveButton() {
        saveButton.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) { [weak self] notif in
            if let amount = UInt(self?.amountTextField.text ?? ""), amount > 0, let price = Double(self?.priceTextField.text ?? ""), price > 0, let symbol = self?.symbolLabel.text, !symbol.isEmpty {
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
    }
}
