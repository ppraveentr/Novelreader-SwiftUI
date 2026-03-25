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
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel: BookDetailViewModel = BookDetailViewModel()
    @State private var selectedTab = 0
    @State private var saved: Bool = false
    let novel: NovelModel
    let onDelete: (() -> Void)

    var body: some View {
        NRScrollView {
            Spacer()
            boodTitle()
            Spacer()
            lastChapter()
            Spacer()
            pickerStyle()
        }
        .onAppear {
            Task {
                viewModel.fetchNovelAndChapters(novel, modelContext: modelContext)
            }
        }
        .onDisappear {
            viewModel.cancelServices()
        }
        .toolbarModifier(.saveNoveButton(novel.isFavorite) {
            Task {
                // Pass onDelete closure to favoriteBook to handle deletion side effects if needed
                viewModel.favoriteBook(novel, onDelete: onDelete)
            }
        })
    }
}

fileprivate extension BookDetailView {

    @ViewBuilder
    func boodTitle() -> some View {
        AlignedStack {
            HStack(spacing: EdgeInsets.contentPadding) {
                // Thumbnail image in the list row
                NRImageView(imageUrl: novel.imageUrl)
                // Novel Title
                AlignedStack {
                    Text(novel.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    if let author = novel.author {
                        AuthorView(author: author)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            Spacer()
            // Book Status View
            statusView()
            Spacer()
            // Rating View
            if let rating = novel.rating {
                RatingView(rating: rating, reviews: novel.views)
            }
            Spacer()
        }
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
        .padding(.edgePadding)

        Group {
            if selectedTab == 0 {
                Text(novel.summary ?? "")
                    .font(.body)
                    .padding(.edgePadding)
            } else {
                BookDetailCard(
                    author: novel.author ?? "",
                    genre: novel.genres,
                    source: novel.source ?? "",
                    status: novel.status ?? ""
                )
            }
        }
        .transition(.opacity)
    }

    @ViewBuilder
    func lastChapter() -> some View {
        SpinnerView(isShowing: viewModel.isChapterDetailsLoading)
        if !viewModel.isChapterDetailsLoading, let lastChapter = novel.lastChapter, let chapters = novel.chapters {
            NavigationLink {
                ChapterListView(novel: chapters)
            } label: {
                HStack {
                    AlignedStack {
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
            .padding(.edgePadding)
        }
    }

    @ViewBuilder
    func statusView() -> some View {
        if let status = novel.status {
            DetailItem(itemType: .status(status == "Completed" ? .completed : .ongoing), value: status, alignment: .hStack)
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
    BookDetailView(novel: model, onDelete: {

    })
}
