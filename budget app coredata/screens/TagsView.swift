//
//  TagsView.swift
//  budget app coredata
//
//  Created by Ram on 13/06/24.
//

import SwiftUI
import CoreData

struct TagsView: View {
    
    @FetchRequest(sortDescriptors: []) private var tags: FetchedResults<Tag>
    @Binding var selectedTag: Set<Tag>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags) { tag in
                    Text(tag.name ?? "")
                        .padding(10)
                        .background(selectedTag.contains(tag) ? .green : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .onTapGesture {
                            if selectedTag.contains(tag) {
                                selectedTag.remove(tag)
                            } else {
                                selectedTag.insert(tag)
                            }
                        }
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct TagsViewContainer: View {
    @State private var tags: Set<Tag> = []
    var body: some View {
        TagsView(selectedTag: $tags)
            .environment(\.managedObjectContext, CoreDataProviders.preivew.context)
    }
}

#Preview {
    TagsViewContainer()
}
