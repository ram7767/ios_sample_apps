//
//  FilterScreen.swift
//  budget app coredata
//
//  Created by Ram on 17/06/24.
//

import SwiftUI
import CoreData

struct FilterScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTags: Set<Tag> = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    @State private var filteredExpenses: [Expense] = []
    
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    
    private func filterTags() {
        if selectedTags.isEmpty {
            return
        }
        
        let selectedTagsName = selectedTags.map { $0.name }
        let request = Expense.fetchRequest()
        
        request.predicate = NSPredicate(format: "ANY tag.name IN %@", selectedTagsName)
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByPrice() {
        guard let startPrice, let endPrice else {return}
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: " cost >= %@ AND cost <= %@", NSNumber(value: startPrice), NSNumber(value: endPrice))
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Section("Filter by tag") {
                TagsView(selectedTag: $selectedTags)
                    .onChange(of: selectedTags, filterTags)
            }
            
            Section("Filter by price") {
                TextField("Start price", value: $startPrice, format: .number)
                TextField("End price", value: $endPrice, format: .number)
                Button("Search") {
                    filterByPrice()
                }
            }
            
            List(filteredExpenses) { expense in
                ExpenseCell(expense: expense)
            }
            Spacer()
            HStack {
                Spacer()
                Button("Show all") {
                    selectedTags = []
                    filteredExpenses = expenses.map { $0 }
                }
                Spacer()
            }
        }
        .navigationTitle("Filter")
        .padding()
    }
}

#Preview {
    NavigationStack {
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProviders.preivew.context)
    }
}
