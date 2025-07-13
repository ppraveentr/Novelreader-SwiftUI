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

    @State private var showingProfile = false
    @StateObject private var viewModel = NovelListViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    // Use the object for localContainer
    @EnvironmentObject private var localProvider: LocalContainerProvider
    // Model Context
    private var modelContext: ModelContext {
        localProvider.container.mainContext
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            NRScrollView(
                onBottomReached: {
                    viewModel.fetchNovels(modelContext: modelContext)
                },
                content: {
                    ResponsiveGrid(viewWidth: width, isLoading: viewModel.isLoading) {
                        listView()
                    }
                }
            )
            .onAppear {
                if viewModel.novels.isEmpty {
                    viewModel.fetchNovels(modelContext: modelContext)
                }
            }
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always))
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
    }

    private func listView() -> some View {
        ForEach(viewModel.novels, id: \.identifier) { novel in
            NavigationLink(destination: BookDetailView(novel: novel).modelContext(modelContext)) {
                BookCellView(novel: novel).modelContext(modelContext)
            }
        }
    }
}
