//
//  NovelView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 26/10/22.
//  Copyright (c) 2022 Praveen P. All rights reserved.
//

import ContentManager
import SwiftData
import SwiftUI

struct NovelListView: View {
    enum DataConstants: String {
        case titleText = "NovelListView.Title"
        case searchPrompt = "NovelListView.SearchPrompt"

        var content: String {
            self.rawValue.localized
        }
    }

    @Environment(\.modelContext) var modelContext
    @State private var searchText: String = ""

    // Keep the initial query separate.
    @Query(sort: \NovelModel.name)
    var allNovels: [NovelModel]

    var filteredNovels: [NovelModel] {
        if searchText.isEmpty {
            return allNovels.filter { !$0.name.isEmpty }
        } else {
            return allNovels.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.author?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }

    var body: some View {
        NRScrollView {
            ForEach(filteredNovels, id: \.identifier) { novel in
                NavigationLink(destination: NovelDetailView(novel: novel)) {
                    NovelView(novel: novel)
                }
            }
        }
        .task {
            do {
                try await NovelServices.syncNovelList(modelContext: modelContext)
            } catch {
                // Optionally handle the error (e.g., print or show alert)
                debugPrint("Failed to sync novel list: \(error)")
            }
        }
        .navigationTitle(DataConstants.titleText.content)
        .searchable(text: $searchText)
        .searchToolbarBehavior(.minimize)
    }
}

// MARK: Preview

#Preview {
    NovelListView()
}
