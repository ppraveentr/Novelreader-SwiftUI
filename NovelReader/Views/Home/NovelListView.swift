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

    @Query var novels: [NovelModel]
    @Environment(\.modelContext) var modelContext
    @State private var showingProfile = false
    @StateObject private var viewModel = NovelListViewModel()

    var body: some View {
        NRScrollView(onBottomReached: {
            viewModel.fetchNovels(modelContext: modelContext)
        }, content: scrollContent)
        .onAppear {
            if novels.isEmpty {
                viewModel.fetchNovels(modelContext: modelContext)
            }
        }
        .navigationTitle(DataConstants.titleText.content + " \(novels.count)")
        .toolbarModifier(.profileButton { showingProfile = true })
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
        .refreshable {
            viewModel.refreshNovels(modelContext: modelContext)
        }
    }

    @ViewBuilder
    func scrollContent() -> some View {
        ForEach(novels, id: \.identifier) { novel in
            NavigationLink(destination: BookDetailView(novel: novel)) {
                BookCellView(novel: novel)
            }
        }
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding()
        }
        if let error = viewModel.error {
            Text("Failed to load novels: \(error.localizedDescription)")
                .foregroundColor(.red)
                .padding()
        }
    }
}
