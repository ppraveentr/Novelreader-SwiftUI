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
        .navigationTitle(novel.name)
        .toolbar(.hidden, for: .tabBar)
    }
}

fileprivate extension BookDetailView {

    @ViewBuilder
    func boodTitle() -> some View {
        HStack(spacing: 8) {
            // Thumbnail image in the list row
            NRImageView(imageUrl: novel.imageUrl)
            VStack(alignment: .leading, spacing: 4) {
                author()
                RatingView(rating: "1", reviews: "3231")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.edgePadding)
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
                Text("After being betrayed by her fiancé and best friend...")
                    .font(.body)
                    .lineLimit(4)
                Button("Read More") {
                    // action to expand synopsis
                }
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
            if let lastChapter = novel.lastChapter {
                NavigationLink {
                    ChapterListView(novel: novel)
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
