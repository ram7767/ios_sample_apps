//
//  BudgetScreen.swift
//  budget app coredata
//
//  Created by Ram on 12/06/24.
//

import SwiftUI
import CoreData

struct BudgetScreen: View {
    
    let budget: Budget
    
    @State private var title: String = ""
    @State private var limit: Int?
    @State private var errorMessage: String = ""
    @State private var selectedTags: Set<Tag> = []
    
    @Environment(\.managedObjectContext) private var context
    @State private var expenses: [Expense] = []
    
    init(budget: Budget) {
        self.budget = budget
//        self._expenses = FetchRequest<Expense>(
//            sortDescriptors: [],
//            predicate: NSPredicate(format: "budget == %@", budget)
//        )
    }
    
    private var total: Double {
        return expenses.reduce(0) { partialResult, expense in
            expense.cost + partialResult
        }
    }
    
    private var remainig: Double {
        return budget.cost - total
    }
    
    private var isFromValid: Bool {
        !title.isEmptyOrWhiteSpaces && limit != nil && limit! > 0 && !selectedTags.isEmpty
    }
    
    private func addExpense() {
        let expense = Expense(context: context)
        expense.title = title
        expense.cost = Double(limit ?? 0)
        expense.date = Date()
        expense.tags = NSSet(array: Array(selectedTags))
        
        do {
            try context.save()
            title = ""
            limit = 0
            errorMessage = ""
            selectedTags = []
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func deleteExpense(_ indexset: IndexSet) {
        indexset.forEach { index in
            let expense = expenses[index]
            context.delete(expense)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            Text(budget.cost, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                .frame(maxWidth: .infinity)
                .padding(8)
        }
        Form {
            Section("Add Expense") {
                TextField("Title", text: $title)
                
                TextField("Budget", value: $limit, format: .number)
                    .keyboardType(.numberPad)
                
                TagsView(selectedTag: $selectedTags)
                
                Button(action: {
                    addExpense()
                }) {
                    Text("Save")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .presentationDetents([.medium])
                .disabled(!isFromValid)
                
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            
            Section("Expenses") {
                List {
                    VStack {
                        HStack {
                            Text("Total")
                            Text(total, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                        }
                        HStack {
                            Text("Remaining")
                            Text(remainig, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                                .foregroundColor(remainig > 0 ? .green : .red)
                        }
                    }
                    ForEach(expenses) { expense in
                        ExpenseCell(expense: expense)
                    }.onDelete(perform: deleteExpense)
                }
            }
        }
        .navigationTitle(budget.title ?? "")
    }
    
}

struct BudgetDetailsScreen: View {
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    var body: some View {
       BudgetScreen(budget: budgets[0])
    }
}

#Preview {
    NavigationStack {
        BudgetDetailsScreen()
            .environment(\.managedObjectContext, CoreDataProviders.preivew.context)
    }
}
