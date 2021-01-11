//
//  PortfolioSharesTableViewCell.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import UIKit

class PortfolioSharesTableViewCell: UITableViewCell {
    @IBOutlet private weak var totalNameLabel: UILabel!
    @IBOutlet private weak var currentPriceNameLabel: UILabel!
    @IBOutlet private weak var countNameLabel: UILabel!
    @IBOutlet private weak var purchaseNameLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var totalCurrentPrice: UILabel!
    @IBOutlet private weak var purchaseLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var totalPurchaseLabel: UILabel!
    @IBOutlet private weak var currentPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 0.5
        setNamesForLabel()
    }
}

extension PortfolioSharesTableViewCell {
    func configure(shareWithPrices: ShareWithPrices) {
        symbolLabel.text = shareWithPrices.share.symbol
        totalCurrentPrice.attributedText = shareWithPrices.totalPriceAndChange
        purchaseLabel.text = String(format: "%.2f", shareWithPrices.share.purchasePrice)
        countLabel.text = String(shareWithPrices.share.count)
        let totalPurchase = shareWithPrices.share.purchasePrice * Double(shareWithPrices.share.count)
        totalPurchaseLabel.text = String(format: "%.2f", totalPurchase)
        currentPriceLabel.attributedText = shareWithPrices.priceAndChange
    }
}

private extension PortfolioSharesTableViewCell {
    func setNamesForLabel() {
        purchaseNameLabel.text = "Purchase:".localized
        countNameLabel.text = "Amount:".localized
        currentPriceNameLabel.text = "Current price:".localized
        totalNameLabel.text = "Total:".localized
    }
}
