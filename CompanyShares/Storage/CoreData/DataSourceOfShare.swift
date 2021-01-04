//
//  DataSourceOfShare.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation
import CoreData

protocol DataSourceOfShareProtocol: class {
    func getShares(portfolio: Portfolio) -> [Share]
    func createShare(name: String, count: Int64, purchasePrice: Double, portfolio: Portfolio)
    func remove(share: Share)
}

class DataSourceOfShare {
    private  var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext) {
        self.context = context
    }
}

// MARK: - DataSourceOfShareProtocol
extension DataSourceOfShare: DataSourceOfShareProtocol {
    func getShares(portfolio: Portfolio) -> [Share] {
        var shares = [Share]()
        let fetchRequest: NSFetchRequest<Share> = Share.fetchRequest()
        let predicate = NSPredicate(format: "portfolio == %@", portfolio)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "symbol", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? context.fetch(fetchRequest) {
            shares = result
        }
        return shares
    }
    
    func createShare(name: String, count: Int64, purchasePrice: Double, portfolio: Portfolio) {
        let share = Share(context: context)
        share.id = UUID().uuidString
        share.symbol = name
        share.count = count
        share.purchasePrice = purchasePrice
        share.currentPrice = 0
        share.portfolio = portfolio
        CoreDataManager.instance.saveContext()
    }
    
    func remove(share: Share) {
        context.delete(share)
        CoreDataManager.instance.saveContext()
    }
}
