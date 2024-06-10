//
//  Budget+extensions.swift
//  budget app coredata
//
//  Created by Ram on 10/06/24.
//

import Foundation
import CoreData

extension Budget {
    
    static func titleIsPresent(context: NSManagedObjectContext, title: String) -> Bool {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            return false
        }
    }
}
