//
//  TagSeeder.swift
//  budget app coredata
//
//  Created by Ram on 13/06/24.
//

import Foundation
import CoreData


class TagSeeder {
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seed(_ commonTags: [String]) throws {
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
            
            try context.save()
            
        }
    }
}
