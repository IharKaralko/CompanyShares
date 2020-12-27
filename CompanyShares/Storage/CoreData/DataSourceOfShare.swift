//
//  DataSourceOfShare.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/14/20.
//

import Foundation
import CoreData

class DataSourceOfShare {
    private  var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext) {
        self.context = context
    }
}

extension DataSourceOfShare {
    func getShares(portfolio: Portfolio) -> [Share] {
        var shares = [Share]()
        let fetchRequest: NSFetchRequest<Share> = Share.fetchRequest()
        let predicate = NSPredicate(format: "portfolio == %@", portfolio)
        fetchRequest.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? context.fetch(fetchRequest) {
            shares = result
        }
        return shares
    }
    
    func createShare(name: String, count: Int64, purchasePrice: Double, portfolio: Portfolio) //-> Share
    {
        let share = Share(context: context)
        share.id = UUID().uuidString
        share.symbol = name
        share.count = count
        share.purchasePrice = purchasePrice
        share.currentPrice = 0
        share.portfolio = portfolio
        CoreDataManager.instance.saveContext()
       // return share
    }
    
    func removeNote(share: Share) {
        context.delete(share)
        CoreDataManager.instance.saveContext()
    }
    
    func updateNote(share: Share, text:String) {
        CoreDataManager.instance.saveContext()
    }
}
