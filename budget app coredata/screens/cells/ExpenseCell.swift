//
//  ExpenseCell.swift
//  budget app coredata
//
//  Created by Ram on 17/06/24.
//

import SwiftUI

struct ExpenseCell: View {
    
    var expense: Expense
    
    var body: some View {
        VStack {
            HStack {
                Text(expense.title ?? "Unknown")
                Spacer()
                Text(expense.cost, format: .currency(code: Locale.current.currency?.identifier ?? ""))
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(expense.tags as? Set<Tag> ?? [])) { tag in
                        Text(tag.name ?? "")
                            .padding(10)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}
