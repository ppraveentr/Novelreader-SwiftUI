//
//  ChapterListView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/21/25.
//

import ContentManager
import SwiftUI

// MARK: - Data Model

struct Chapter: Identifiable {
    let id = UUID()
    let chapterNumber: Int
    let title: String
}

// MARK: - Paginated List View

struct ChapterListView: View {
    let novel: NovelModel
    // All chapters (3000) are precomputed.
    private let allChapters: [Chapter] = (1...3000).map {
        Chapter(chapterNumber: $0, title: "Chapter \($0)")
    }

    // State for the currently displayed chapters.
    @State private var displayedChapters: [Chapter] = []
    @State private var currentPage: Int = 0
    private let itemsPerPage: Int = 100

    @State private var searchText: String = ""
    @State private var isLoadingMore: Bool = false

    var filteredChapters: [Chapter] {
        if searchText.isEmpty {
            return displayedChapters
        } else {
            return allChapters.filter { chapter in
                chapter.title.localizedCaseInsensitiveContains(searchText) ||
                String(chapter.chapterNumber).contains(searchText)
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(filteredChapters) { chapter in
                    NavigationLink(destination: ChapterDetailView(chapter: chapter)) {
                        ChapterRowView(chapter: chapter)
                    }
                    .onAppear {
                        handleChapterAppear(chapter)
                    }
                }

                if searchText.isEmpty && displayedChapters.count < allChapters.count && isLoadingMore {
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
                        Text("(\(allChapters.count))")
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
        guard startIndex < allChapters.count else { return }
        isLoadingMore = true
        let endIndex = min(startIndex + itemsPerPage, allChapters.count)
        let newChapters = Array(allChapters[startIndex..<endIndex])
        displayedChapters.append(contentsOf: newChapters)
        currentPage += 1
        isLoadingMore = false
    }

    private func handleChapterAppear(_ chapter: Chapter) {
        guard searchText.isEmpty else { return }
        if chapter.id == displayedChapters.last?.id {
            loadMoreChapters()
        }
    }
}

fileprivate struct ChapterRowView: View {
    let chapter: Chapter
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 34, height: 34)
                Text("\(chapter.chapterNumber)")
                    .font(.subheadline).foregroundColor(.blue)
            }
            Text(chapter.title)
                .font(.headline)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Preview

#Preview {
    let model = {
        let novel = NovelModel(identifier: "sds", name: "sds")
        novel.author = "Author"
        novel.lastChapter = "2165 Chapters"
        return novel
    }()
    return ChapterListView(novel: model)
}
