//
//  CompanyPortfolioSharesTableViewCell.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/17/20.
//

import UIKit

class CompanyPortfolioSharesTableViewCell: UITableViewCell {

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

extension CompanyPortfolioSharesTableViewCell {
    func configure(share: ShareWithPrices) {
        symbolLabel.text = share.share.symbol
        totalCurrentPrice.attributedText = share.totalPriceAndChange
        purchaseLabel.text = String(share.share.purchasePrice)
        countLabel.text = String(share.share.count)
        totalPurchaseLabel.text = String(share.share.purchasePrice * Double(share.share.count))
            currentPriceLabel.attributedText = share.priceAndChange
        }
}

private extension CompanyPortfolioSharesTableViewCell {
    func setNamesForLabel() {
        purchaseNameLabel.text = "Purchase:".localized
        countNameLabel.text = "Amount:".localized
        currentPriceNameLabel.text = "Current price:".localized
        totalNameLabel.text = "Total:".localized
        
    }
}
