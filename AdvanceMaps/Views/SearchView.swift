//
//  SearchView.swift
//  AdvanceMaps
//
//  Created by Ram on 18/06/24.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var search: String
    var onSearch: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .frame(maxWidth: .infinity, maxHeight: 40)
                .foregroundColor(Color(#colorLiteral(red: 0.3250313401, green: 0.6773762703, blue: 1, alpha: 0.6132069283)))
            HStack(spacing: 20) {
                Image(systemName: "location.magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                TextField("Search", text: $search)
                
                Button("Search") {
                    onSearch()
                }
            }
            .padding()
        }
        .padding()
    }
}
