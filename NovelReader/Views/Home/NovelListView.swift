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

    // Use the object for localContainer
    @EnvironmentObject private var localProvider: LocalContainerProvider
    private var modelContext: ModelContext {
        localProvider.container.mainContext
    }

    @State private var showingProfile = false
    @StateObject private var viewModel = NovelListViewModel()

    var body: some View {
        NRScrollView(onBottomReached: {
            viewModel.fetchNovels(modelContext: modelContext)
        }, content: scrollContent)
        .onAppear {
            if viewModel.novels.isEmpty {
                viewModel.fetchNovels(modelContext: modelContext)
            }
        }
        .navigationTitle(DataConstants.titleText.content + " \(viewModel.novels.count)")
        .toolbarModifier(.profileButton { showingProfile = true })
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
        .refreshable {
            viewModel.refreshNovels(modelContext: modelContext)
        }
        .bannerOverlay(.error(viewModel.error)) {
            viewModel.error = nil
        }
    }

    @ViewBuilder
    func scrollContent() -> some View {
        ForEach(viewModel.novels, id: \.identifier) { novel in
            NavigationLink(destination: BookDetailView(novel: novel).modelContext(modelContext)) {
                BookCellView(novel: novel).modelContext(modelContext)
            }
        }
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
}
