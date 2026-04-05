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
    @State private var isSummaryExpanded: Bool = false
    let novel: NovelModel
    let onDelete: (() -> Void)

    var body: some View {
        NRScrollView {
            BookTitleView(novel: novel, showLastChapter: false)
            Spacer()
            // Book Status View
            BookDetailCard(source: novel.source, status: novel.status, rating: rating())
            Spacer()
            ExpandableText(text: novel.summary ?? "", lineLimit: 5, font: .body)
            Spacer()
            lastChapter()
        }
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .center) {
                Spacer()
                SpinnerView(isShowing: viewModel.isChapterDetailsLoading)
                if !viewModel.isChapterDetailsLoading {
                    Text("Read Now")
                        .font(.headline)
                }
                Spacer()
            }
            .padding(.edgePadding)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 16))
            .padding(EdgeInsets.contentSpacing)
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
    func pickerStyle() -> some View {
        Text(novel.summary ?? "")
            .font(.body)
        .padding(.edgePadding)
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
                        Text("Last Chapter: " + lastChapter)
                            .font(.headline)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .contentShape(Rectangle())
                .foregroundColor(.primary)
            }
            .buttonStyle(.plain)
            .padding(.edgeSidePadding)
        }
    }

    func rating() -> RatingModel? {
        // Rating View
        guard let rating = novel.rating, let value = Double(rating) else {
            return nil
        }
        return RatingModel(rating: value, reviews: novel.views)
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
