//
//  ListBudgestScreen.swift
//  budget app coredata
//
//  Created by Ram on 10/06/24.
//

import SwiftUI
import CoreData

struct ListOfBudgets: View {
    
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            List(budgets) { budget in
                HStack {
                    Text(budget.title ?? "")
                    Spacer()
                    Text(budget.cost, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                }
            }
        }
        .navigationTitle("Budget App")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Budget") {
                    isPresented = true
                }
            }
        }
        .sheet(isPresented: $isPresented, content: {
            AddBudgetScreen()
        })
    }
}

#Preview {
    NavigationStack {
        ListOfBudgets()
    }
    .environment(\.managedObjectContext, CoreDataProviders.preivew.context)
}
