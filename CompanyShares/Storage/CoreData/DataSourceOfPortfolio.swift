//
//  DataSourceOfPortfolio.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/11/20.
//

import Foundation
import CoreData

protocol DataSourceOfPortfolioProtocol: class {
    func getPortfolios() -> [Portfolio]
    func createPortfolio(name: String)
    func remove(portfolio: Portfolio)
    func update(portfolio: Portfolio, name: String)
}

class DataSourceOfPortfolio {
    private  var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext) {
        self.context = context
    }
}

// MARK: - DataSourceOfPortfolioProtocol
extension DataSourceOfPortfolio: DataSourceOfPortfolioProtocol {
    func getPortfolios() -> [Portfolio] {
        var portfolios = [Portfolio]()
        let fetchRequest = createFetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            portfolios = result
        }
        return portfolios
    }
    
    func createPortfolio(name: String) {
        let portfolio = Portfolio(context: context)
        portfolio.id = UUID().uuidString
        portfolio.name = name
        CoreDataManager.instance.saveContext()
    }
    
    func remove(portfolio: Portfolio) {
        context.delete(portfolio)
        CoreDataManager.instance.saveContext()
    }
    
    func update(portfolio: Portfolio, name: String) {
        let fetchRequest = createFetchRequest()
        guard let id = portfolio.id else { return }
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        if let result = try? context.fetch(fetchRequest) {
            if let objectToUpdate = result.first {
                objectToUpdate.setValue(name, forKey: "name")
                CoreDataManager.instance.saveContext()
            }
        }
    }
}

private extension DataSourceOfPortfolio {
    func createFetchRequest() -> NSFetchRequest<Portfolio> {
        let fetchRequest: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}
