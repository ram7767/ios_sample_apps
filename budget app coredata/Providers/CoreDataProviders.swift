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
