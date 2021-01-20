//
//  Utility.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/20/21.
//

import UIKit

class Utility {
   class func getAttributedString(purchasePrice: Double, currentPrice: Double, isTotalPrice: Bool) -> NSMutableAttributedString {
        let currentPriceString = String(format: "%.2f", currentPrice)
        let attributedString = NSMutableAttributedString(string: currentPriceString, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        var attrs: [NSAttributedString.Key : Any]
        
        if purchasePrice > currentPrice {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.red]
        }
        else {
            attrs = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        }
        
        let change = currentPrice - purchasePrice
        let changePercent = (change / purchasePrice) * 100
        let changeString = String(format: "%.2f", change)
        let changePercentString = String(format: "%.2f", changePercent)
        let changeItog: String
        if !isTotalPrice {
            changeItog = "  " + changeString + " (" + changePercentString + "%)"
        } else {
            changeItog = "  " + changeString
        }
        
        let attributedChange = NSMutableAttributedString(string: changeItog, attributes: attrs)
        attributedString.append(attributedChange)
        return attributedString
    }
}
