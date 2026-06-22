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
        isInverted ? novel.chapters.sorted { $0.index > $1.index } : novel.chapters.sorted { $0.index < $1.index }
    }

    @Environment(\.modelContext) var modelContext
    @State private var searchText: String = ""
    @State private var isInverted: Bool = false

    var filteredChapters: [NovelChapterModel] {
        if searchText.isEmpty {
            return chapters
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
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Chapters (\(chapters.count))")
        .searchToolbarBehavior(.minimize)
        .scrollDismissesKeyboard(.interactively)
        .searchable(text: $searchText, placement: .toolbarPrincipal, prompt: "Search chapters or number")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isInverted.toggle()
                }, label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .rotationEffect(isInverted ? .degrees(180) : .degrees(0))
                        .imageScale(.medium)
                        .foregroundColor(.accentColor)
                        .accessibilityLabel("Sort order")
                })
                .help("Invert chapter sort order")
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

private struct ChapterRowView: View {
    let chapter: NovelChapterModel
    var body: some View {
        HStack {
            ZStack {
                Capsule()
                    .fill(Color.blue.opacity(0.15))
                    .frame(height: 34)
                Text("\(chapter.index)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
            }
            .fixedSize()
            .frame(height: 34)
            Spacer()
            Text(chapter.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
