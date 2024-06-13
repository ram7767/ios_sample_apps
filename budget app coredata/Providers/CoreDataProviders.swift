//
//  CoreDataProviders.swift
//  budget app coredata
//
//  Created by Ram on 10/06/24.
//

import Foundation
import CoreData

class CoreDataProviders {
    
    let persistantContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistantContainer.viewContext
    }
    
   static let preivew: CoreDataProviders = {
        let provider = CoreDataProviders(inMemory: true)
        let context = provider.context
        
        let smaple = Budget(context: context)
        smaple.title = "Trip"
        smaple.cost = 5000
        smaple.dateCreated = Date()
       
//       let tent = Expense(context: context)
//       tent.title = "Tent"
//       tent.cost = 500
//       tent.date = Date()
//       let tag = Tag(context: context)
//       tag.name = "Food"
//       tent.tags = [tag]
//       smaple.addToExpenses(tent)
       
       let commonTags = ["Food", "Shopping", "Entertainment", "Travel", "Dining",
                         "Groceries", "Health", "Education", "Transportation"]
       
       for commonTag in commonTags {
           let tag = Tag(context: context)
           tag.name = commonTag
       }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        return provider
        
    }()
    
    init(inMemory: Bool = false) {
        self.persistantContainer = NSPersistentContainer(name: "BudgetModel")
        
        if inMemory {
            persistantContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistantContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core data failed to load. \(error)")
            }
        }
    }
}
