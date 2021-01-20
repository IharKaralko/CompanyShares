//
//  BuyAndSellSharesModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 1/11/21.
//

import Foundation

enum  BuyAndSellShares {
    enum LoadPrice {
        struct Request {
            let symbol: String
        }
        struct Response {
            let price: String
        }
        struct ViewModel {
            let price: String
        }
    }
    
    enum AddShare {
        struct Request {
            let newShare: NewShare
        }
    }
    
    enum RemoveShare {
        struct Request {
            let share: Share
        }
    }
    
    enum UpdateShareAmount {
        struct Request {
            let share: Share
            let amount: Int64
        }
    }
    
    enum ShowResultOfSale {
        struct Request {
            let share: Share
            let amount: Int64
            let price: Double
        }
        struct Response {
            let purchasePrice: Double
            let currentPrice: Double
        }
        struct ViewModel {
            let result: NSMutableAttributedString
        }
    }
}
