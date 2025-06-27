//
//  LibaryView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 26/10/22.
//  Copyright (c) 2022 Praveen P. All rights reserved.
//

import ContentManager
import SwiftData
import SwiftUI

struct LibaryView: View {
    enum DataConstants: String {
        case titleText = "LibaryView.Title"
        case searchPrompt = "LibaryView.SearchPrompt"

        var content: String {
            self.rawValue.localized
        }
    }

    @Environment(\.modelContext) var modelContext
    @State private var searchText: String = ""
    @State private var showingProfile = false
    // Keep the initial query separate.
    @Query private var allNovels: [NovelModel]

    var filteredNovels: [NovelModel] {
        allNovels.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.author?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }

    var body: some View {
        NRScrollView {
            ForEach(filteredNovels, id: \.identifier) { novel in
                NavigationLink(destination: BookDetailView(novel: novel)) {
                    BookCellView(novel: novel)
                }
            }
        }
        .navigationTitle(DataConstants.titleText.content)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .searchToolbarBehavior(.minimize)
        .scrollDismissesKeyboard(.automatic)
        .toolbarModifier(.profileButton { showingProfile = true })
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

// MARK: Preview

#Preview {
    LibaryView()
}
