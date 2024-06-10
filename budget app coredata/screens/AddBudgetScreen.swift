//
//  AddBudgetScreen.swift
//  budget app coredata
//
//  Created by Ram on 10/06/24.
//

import SwiftUI
import CoreData

struct AddBudgetScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @State private var title: String = ""
    @State private var limit: Int?
    @State private var errorMessage: String = ""
    
    private var isFromValid: Bool {
        !title.isEmptyOrWhiteSpaces && limit != nil && limit! > 0
    }
    
    private func saveBudget() {
        let budget = Budget(context: context)
        budget.title = title
        budget.cost = Double(limit ?? 0)
        budget.dateCreated = Date()
        
        do {
            try context.save()
            errorMessage = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        Form {
            Text("New Budget")
                .font(.title)
                .font(.headline)
            
            TextField("Title", text: $title)
            
            TextField("Budget", value: $limit, format: .number)
            .keyboardType(.numberPad)
            
            Button(action: {
                if !Budget.titleIsPresent(context: context, title: title) {
                    saveBudget()
                } else {
                    errorMessage = "This title is alredy exists"
                }
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
    }
}

#Preview {
    AddBudgetScreen()
        .environment(\.managedObjectContext, CoreDataProviders(inMemory: true).context)
}
