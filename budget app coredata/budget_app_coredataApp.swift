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
    let tagseeder: TagSeeder
    
    init() {
        self.provider = CoreDataProviders()
        self.tagseeder = TagSeeder(context: provider.context)
    }
    
    var body: some Scene {
        WindowGroup {
            ListOfBudgets()
                .onAppear {
                    let hasSeedData = UserDefaults.standard.bool(forKey: "hasSeedData")
                    if !hasSeedData {
                        let commonTags = ["Food", "Shopping", "Entertainment", "Travel", "Dining",
                                          "Groceries", "Health", "Education", "Transportation"]
                        do {
                            try   tagseeder.seed(commonTags)
                            UserDefaults.standard.setValue(true, forKey: "hasSeedData")
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
