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

    // Use the object for localContainer
    @EnvironmentObject private var localProvider: LocalContainerProvider
    // Model Context
    private var modelContext: ModelContext {
        localProvider.container.mainContext
    }

    var body: some View {
        GeometryReader { geo in
            mainBody(for: geo)
                .onAppear {
                    if viewModel.novels.isEmpty {
                        viewModel.fetchNovels(modelContext)
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
    }
}

private extension NovelListView {

    func mainBody(for geo: GeometryProxy) -> some View {
        AlignedStack(.hStack(.top), spacing: 0) {
            NavigationStack {
                novelGridView(geo.size.width)
            }
        }
    }

    func novelGridView(_ width: CGFloat) -> some View {
        NRScrollView(
            onBottomReached: {
                viewModel.fetchNovels(modelContext)
            },
            content: {
                ResponsiveGrid(width: width, shrinkedView: viewModel.selectedNovel != nil, isLoading: viewModel.isLoading) {
                    listView()
                }
            }
        )
        // Apply searchable only here to scope search to the novel list view and avoid conflicts with detail view
        .searchable(text: $viewModel.searchQuery)
    }

    func listView() -> some View {
        ForEach(viewModel.novels, id: \.identifier) { novel in
            NavigationLink(destination: bookDetailsDestination(novel)) {
                BookTitleView(novel: novel)
                    .modelContext(modelContext)
            }
        }
        .modifier(ConditionalGlassEffect())
    }

    func bookDetailsDestination(_ novel: NovelModel) -> some View {
        BookDetailView(novel: novel) {
            // Prevent crash if novel is deleted
            viewModel.selectedNovel = nil
        }
        .modelContext(modelContext)
    }
}

#Preview("Novel List") {
    NavigationStack {
        NovelListView()
    }
}
