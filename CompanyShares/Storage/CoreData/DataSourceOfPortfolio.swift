//
//  DataSourceOfPortfolio.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/11/20.
//

import Foundation
import CoreData

protocol DataSourceOfPortfolioProtocol: class {
    func getPortfolios()  -> [Portfolio]
    func createPortfolio(name: String) //-> Portfolio
    func removePortfolio(portfolio: Portfolio)
    func updatePortfolio(portfolio: Portfolio, name: String)
    
}

class DataSourceOfPortfolio {
    private  var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext) {
        self.context = context
    }
}

extension DataSourceOfPortfolio: DataSourceOfPortfolioProtocol {
    func getPortfolios() -> [Portfolio] {
        var portfolios = [Portfolio]()
        let fetchRequest = createFetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            portfolios = result
        }
        return portfolios
    }
    
    func createPortfolio(name: String) { //}-> Portfolio {
        let portfolio = Portfolio(context: context)
        portfolio.id = UUID().uuidString
        portfolio.name = name
        CoreDataManager.instance.saveContext()
       // return portfolio
    }
    
//    func createNotebookForFRC(name: String) {
//        let notebook = Notebook(context: context)
//        notebook.name = name
//        notebook.creationDate = Date()
//        CoreDataManager.instance.saveContext()
//    }
    
    func removePortfolio(portfolio: Portfolio) {
        context.delete(portfolio)
        CoreDataManager.instance.saveContext()
    }
    
//    func setupFetchedResultsController() -> NSFetchedResultsController<Notebook> {
//        let fetchRequest = createFetchRequest()
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "notebooks")
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            fatalError("The fetch could not be performed: \(error.localizedDescription)")
//        }
//        return fetchedResultsController
//    }
    
    private func createFetchRequest() -> NSFetchRequest<Portfolio> {
        let fetchRequest: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func updatePortfolio(portfolio: Portfolio, name: String) {
        let fetchRequest = createFetchRequest()
        guard let id = portfolio.id else { return }
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
//        do {
//            let result = try? context.fetch(fetchRequest)
//        }
        if let result = try? context.fetch(fetchRequest) {
            if let objectToUpdate = result.first as? NSManagedObject
            {
                objectToUpdate.setValue(name, forKey: "name")
                CoreDataManager.instance.saveContext()
            }
    }
    
}
}
