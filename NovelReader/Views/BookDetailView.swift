//
//  BookDetailView.swift
//  NovelReader
//
//  Created by Praveen P on 3/3/24.
//  Copyright (c) 2024 Praveen P. All rights reserved.
//

import ContentManager
import SwiftUI

enum BookDetailRoute: Hashable {
    case chapterList
}

struct BookDetailView: View {
    let novel: NovelModel
    @Environment(\.modelContext) var modelContext
    @State private var selectedTab = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                boodTitle()
                lastChapter()
                pickerStyle()
            }
            .padding()
        }
        .task {
            do {
                try await NovelServices.syncNovelDetails(novel, modelContext: modelContext)
            } catch {
                debugPrint("Failed to sync novel Details: \(error)")
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

fileprivate extension BookDetailView {

    @ViewBuilder
    func boodTitle() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                // Thumbnail image in the list row
                NRImageView(imageUrl: novel.imageUrl)
                // Novel Title
                VStack(alignment: .leading, spacing: 4) {
                    Text(novel.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    author()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.edgePadding)
            RatingView(rating: "1", reviews: "3231")
        }
    }

    @ViewBuilder
    func pickerStyle() -> some View {
        Picker("", selection: $selectedTab) {
            Text("Synopsis").tag(0)
            Text("Book Detail").tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.vertical)

        Group {
            if selectedTab == 0 {
                Text("Synopsis")
                    .font(.headline)
                Text(novel.summary ?? "")
                    .font(.body)
            } else {
                BookDetailCard(
                    author: "Passion Honey, 百香蜜",
                    genre: "Romance, Drama, Josei",
                    source: "Qidian International",
                    status: "Completed"
                )
            }
        }
        .transition(.opacity)
    }

    func lastChapter() -> some View {
        Group {
            if let lastChapter = novel.lastChapter, let chapters = novel.chapters {
                NavigationLink {
                    ChapterListView(novel: chapters)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Last Chapter")
                                .font(.headline)
                            Text(lastChapter)
                                .font(.body)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .contentShape(Rectangle())
                    .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
            } else {
                EmptyView()
            }
        }
    }

    func author() -> some View {
        Group {
            if let author = novel.author {
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.secondary)
                    Text(author)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } else {
                EmptyView()
            }
        }
    }

}

// MARK: Preview

#Preview {
    let model = {
        let novel = NovelModel(identifier: "sds", name: "sds")
        novel.author = "Author"
        novel.lastChapter = "2165 Chapters"
        return novel
    }()
    BookDetailView(novel: model)
}
