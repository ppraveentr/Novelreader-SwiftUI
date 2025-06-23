//
//  ChapterListView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/21/25.
//

import ContentManager
import SwiftUI
import SwiftData

// MARK: - Paginated List View

struct ChapterListView: View {
    var novel: NovelChapterPaginationModel
    var chapters: [NovelChapterModel] {
        novel.chapters.sorted { $0.index < $1.index }
    }

    // State for the currently displayed chapters.
    @State private var displayedChapters: [NovelChapterModel] = []
    @State private var currentPage: Int = 0
    private let itemsPerPage: Int = 5 // Adjusted page size

    @State private var searchText: String = ""
    @State private var isLoadingMore: Bool = false

    var filteredChapters: [NovelChapterModel] {
        if searchText.isEmpty {
            return displayedChapters
        } else {
            return chapters.filter { chapter in
                chapter.name.localizedCaseInsensitiveContains(searchText) ||
                String(chapter.index).contains(searchText)
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(filteredChapters, id: \.identifier) { chapter in
                    NavigationLink(destination: ChapterDetailView(chapter: chapter)) {
                        ChapterRowView(chapter: chapter)
                    }
                    .onAppear {
                        handleChapterAppear(chapter)
                    }
                }

                if searchText.isEmpty && displayedChapters.count < chapters.count && isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
            .listStyle(PlainListStyle())
        }
        .task {
//            do {
//                try await NovelServices.syncNovelChapterList(novel, page: <#T##Int#>, modelContext: <#T##ModelContext#>)
//            } catch {
//                debugPrint("Failed to sync novel Details: \(error)")
//            }
        }
        .onAppear {
            // Load the initial page.
            if displayedChapters.isEmpty {
                loadMoreChapters()
            }
        }
        .navigationTitle("Chapters")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Group {
                    if searchText.isEmpty {
                        Text("(\(chapters.count))")
                    } else {
                        Text("(\(filteredChapters.count))")
                    }
                }
                .foregroundColor(.secondary)
                .font(.footnote)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(minWidth: 36, alignment: .trailing)
            }
            ToolbarItem(placement: .bottomBar) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    TextField("Search", text: $searchText)
                }
                .padding(.vertical, 4)
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }

    private func loadMoreChapters() {
        guard !isLoadingMore else { return }
        let startIndex = currentPage * itemsPerPage
        guard startIndex < chapters.count else { return }
        isLoadingMore = true
        let endIndex = min(startIndex + itemsPerPage, chapters.count)
        let newChapters = Array(chapters[startIndex..<endIndex])
        displayedChapters.append(contentsOf: newChapters)
        currentPage += 1
        isLoadingMore = false
    }

    private func handleChapterAppear(_ chapter: NovelChapterModel) {
        guard searchText.isEmpty else { return }
        if chapter.id == displayedChapters.last?.id {
            loadMoreChapters()
        }
    }
}

private struct ChapterRowView: View {
    let chapter: NovelChapterModel
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 34, height: 34)
                Text("\(chapter.index)")
                    .font(.subheadline).foregroundColor(.blue)
            }
            Text(chapter.name)
                .font(.headline)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Preview

//#Preview {
//    let model: [NovelChapterModel] = {
//        let novel = NovelModel(identifier: "sds", name: "sds")
//        novel.author = "Author"
//        novel.lastChapter = "2165 Chapters"
//        novel.chapters = Array(1...2165).map(\.description)
//        return novel.chapters
//    }()
//    return ChapterListView(chapters: model)
//}
