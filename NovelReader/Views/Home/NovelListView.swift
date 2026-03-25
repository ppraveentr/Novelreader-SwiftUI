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
            mainBody(for: geo)
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
    }
}

private extension NovelListView {
    var isPhone: Bool {
        horizontalSizeClass == .compact
    }

    func novelGridView(_ width: CGFloat) -> some View {
        NRScrollView(
            onBottomReached: {
                viewModel.fetchNovels(modelContext: modelContext)
            },
            content: {
                ResponsiveGrid(viewWidth: width, shrinkedView: viewModel.selectedNovel != nil, isLoading: viewModel.isLoading) {
                    listView()
                }
            }
        )
        // Apply searchable only here to scope search to the novel list view and avoid conflicts with detail view
        .searchable(text: $viewModel.searchQuery)
    }

    func formatedWidth(_ geo: GeometryProxy) -> CGFloat {
        let wid = geo.size.width
        if isPhone || viewModel.selectedNovel == nil {
            return wid
        }
        return geo.size.width * 0.4
    }

    func mainBody(for geo: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            // Left side: novel grid/list view with search capability, in its own NavigationStack so search bar is scoped ONLY to the grid
            NavigationStack {
                novelGridView(geo.size.width)
            }
            .frame(width: formatedWidth(geo))
            // Right side: detail view, no search here to avoid conflicting focus
            if !isPhone, let novel = viewModel.selectedNovel {
                Divider()
                BookDetailView(novel: novel) {
                    // Prevent crash if novel is deleted
                    viewModel.selectedNovel = nil
                }
                    .id(novel.identifier)
                    .modelContext(modelContext)
                    .frame(width: geo.size.width * 0.6)
                    .transition(.move(edge: .trailing))
            }
        }
    }

    func listView() -> some View {
        ForEach(viewModel.novels, id: \.identifier) { novel in
            let des = { novel in
                BookDetailView(novel: novel) {
                    // Prevent crash if novel is deleted
                    viewModel.selectedNovel = nil
                }
                .modelContext(modelContext)
            }
            if isPhone {
                NavigationLink(destination: des(novel)) {
                    BookCellView(novel: novel).modelContext(modelContext)
                }
            } else {
                BookCellView(novel: novel)
                    .modelContext(modelContext)
                    .onTapGesture {
                        viewModel.selectedNovel = novel
                    }
            }
        }
    }
}
