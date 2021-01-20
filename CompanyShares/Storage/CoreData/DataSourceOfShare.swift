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
    func remove(share: Share)
    func update(share: Share, currentPrice: Double?, amount: Int64?)
    func createShare(_ newShare: NewShare)
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
    
    func createShare(_ newShare: NewShare) {
        let share = Share(context: context)
        share.id = UUID().uuidString
        share.symbol = newShare.symbol
        share.amount = newShare.amount
        share.purchasePrice = newShare.purchasePrice
        share.currentPrice = newShare.currentPrice
        share.date = Date()
        share.portfolio = newShare.portfolio
        CoreDataManager.instance.saveContext()
    }
    
    func update(share: Share, currentPrice: Double?, amount: Int64?) {
        let fetchRequest: NSFetchRequest<Share> = Share.fetchRequest()
        guard let id = share.id else { return }
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        if let result = try? context.fetch(fetchRequest) {
            if let objectToUpdate = result.first {
                guard let currentPrice = currentPrice else {
                    guard let amount = amount else { return }
                    objectToUpdate.setValue(amount, forKey: "amount")
                    CoreDataManager.instance.saveContext()
                    return
                }
                objectToUpdate.setValue(currentPrice, forKey: "currentPrice")
                objectToUpdate.setValue(Date(), forKey: "date")
                CoreDataManager.instance.saveContext()
            }
        }
    }
    
    func remove(share: Share) {
        context.delete(share)
        CoreDataManager.instance.saveContext()
    }
}
