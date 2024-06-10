//
//  budget_app_coredataApp.swift
//  budget app coredata
//
//  Created by Ram on 10/06/24.
//

import SwiftUI

@main
struct budget_app_coredataApp: App {
    
    let provider: CoreDataProviders
    
    init() {
        self.provider = CoreDataProviders()
    }
    
    var body: some Scene {
        WindowGroup {
            ListOfBudgets()
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
