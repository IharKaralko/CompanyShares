//
//  BuyAndSellSharesViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/10/21.
//

import UIKit

protocol BuyAndSellSharesDisplayLogic: class {
    func displayPrice(viewModel: BuyAndSellShares.LoadPrice.ViewModel)
    func displayResult(viewModel: BuyAndSellShares.ShowResultOfSale.ViewModel)
}

protocol BuyAndSellSharesViewControllerProtocol: class {
    func addShares(company: Company)
}

class BuyAndSellSharesViewController: UIViewController {
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var tickerLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var resultView: UIView!
    @IBOutlet private weak var resultOperationLabel: UILabel!
    private var currentPrice: Double = 0
    
    var interactor: BuyAndSellSharesBusinessLogic?
    var portfolio: Portfolio?
    var routerDelegate: CompanyListRouterProtocol?
    var isSellShare: Bool?
    var shareWithPrices: ShareWithPrices?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        BuyAndSellSharesConfigurator.shared.configure(with: self)
        setLabels()
        setSaveButton()
        setShareForSale()
        setTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) { NotificationCenter.default.removeObserver(self)
    }
}

private extension BuyAndSellSharesViewController {
    @IBAction func saveAction(_ sender: UIButton) {
        guard let isSellShare = isSellShare,
              let portfolio = portfolio,
              let symbol = symbolLabel.text,
              let amount = Int64(amountTextField.text ?? ""),
              let price = Double(priceTextField.text ?? "") else { return }
        if !isSellShare {
            let newShare = NewShare(symbol: symbol, amount: amount, purchasePrice: price, currentPrice: currentPrice, portfolio: portfolio)
            let request = BuyAndSellShares.AddShare.Request(newShare: newShare)
            interactor?.addShare(request)
            routerDelegate?.popVC()
        } else {
            self.view.endEditing(true)
            guard let shareWithPrices = shareWithPrices else { return }
            if amount == shareWithPrices.share.amount {
                let request = BuyAndSellShares.RemoveShare.Request(share: shareWithPrices.share)
                interactor?.removeShare(request)
            } else {
                let newAmount = shareWithPrices.share.amount - amount
                let request = BuyAndSellShares.UpdateShareAmount.Request(share: shareWithPrices.share, amount: newAmount)
                interactor?.updateShareAmount(request)
            }
            saveButton.isEnabled = false
            let request = BuyAndSellShares.ShowResultOfSale.Request(share: shareWithPrices.share, amount: amount, price: price)
            interactor?.showResultOfSale(request)
        }
    }
    
    func setTitle() {
        navigationItem.title = "BuyAndSellShares_Share_Sale".localized
    }
    
    func setLabels() {
        infoLabel.text = "BuyAndSellShares_Enter_shares_details".localized
        tickerLabel.text = "BuyAndSellShares_Ticker".localized
        amountLabel.text = "BuyAndSellShares_Amount".localized
        priceLabel.text = "BuyAndSellShares_Price".localized
        resultLabel.text = "BuyAndSellShares_Result_of_operation".localized
    }
    
    func setSaveButton() {
        guard let isSellShare = isSellShare else { return }
        saveButton.isEnabled = isSellShare
        
        saveButton.layer.cornerRadius = 10
        saveButton.setTitle("BuyAndSellShares_Save".localized, for: .normal)
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) { [weak self] notif in
            if let amount = Int(self?.amountTextField.text ?? ""), amount > 0, self?.checkAmountForSale(amount) ?? true, let price = Double(self?.priceTextField.text ?? ""), price > 0, let symbol = self?.symbolLabel.text, !symbol.isEmpty {
                self?.saveButton.isEnabled = true
            } else {
                self?.saveButton.isEnabled = false
            }
        }
    }
    
    func setShareForSale() {
        guard let isSellShare = isSellShare, let shareWithPrices = shareWithPrices else { return }
        if isSellShare {
            symbolLabel.text = shareWithPrices.share.symbol
            amountTextField.text = String(shareWithPrices.share.amount)
            priceTextField.text = String(shareWithPrices.share.currentPrice)
        }
    }
    
    func checkAmountForSale(_ amount: Int) -> Bool {
        guard let isSellShare = isSellShare else { return false }
        if isSellShare {
            guard let shareWithPrices = shareWithPrices else { return false }
            if shareWithPrices.share.amount < amount {
                return false
            }
        }
        return true
    }
}

// MARK: - BuyAndSellSharesViewControllerProtocol
extension BuyAndSellSharesViewController: BuyAndSellSharesViewControllerProtocol {
    func addShares(company: Company) {
        symbolLabel.text = company.symbol
        let request = BuyAndSellShares.LoadPrice.Request(symbol: company.symbol)
        interactor?.loadPrice(request)
    }
}

// MARK: - BuyAndSellSharesDisplayLogic
extension BuyAndSellSharesViewController: BuyAndSellSharesDisplayLogic {
    func displayResult(viewModel: BuyAndSellShares.ShowResultOfSale.ViewModel) {
        resultView.isHidden = false
        resultOperationLabel.attributedText = viewModel.result
    }
    
    func displayPrice(viewModel: BuyAndSellShares.LoadPrice.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.priceTextField.text = viewModel.price
            self?.currentPrice = Double(viewModel.price) ?? 0
        }
    }
}
