//
//  NovelView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 2/16/25.
//

import ContentManager
import SwiftUI

struct BookCellView: View {
    var novel: NovelModel

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        VStack {
            AlignedStack(.hAlignedStack(alignment: .center)) {
                // Thumbnail image in the list row
                NRImageView(imageUrl: novel.imageUrl)
                // Novel information: title and author are shown in the list row
                AlignedStack(.vStack) {
                    Text(novel.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    // Author
                    if let author = novel.author {
                        AuthorView(author: author)
                    }
                    // iPad
                    if horizontalSizeClass == .regular {
                        lastChapterView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                // iPhone
                if horizontalSizeClass != .regular {
                    Spacer()
                    // Last chapter View
                    lastChapterView()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.edgePadding)

            // Divider to separate rows
            Divider()
                .padding(.edgePadding)
        }
    }

    func lastChapterView() -> some View {
        Group {
            // Show last chapter info in a smaller font
            if let lastChapter = novel.lastChapter {
                Text(lastChapter)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    let model = {
        let novel = NovelModel(identifier: "sds", name: "sds")
        novel.author = "Author"
        novel.lastChapter = "2165 Chapters"
        return novel
    }()
    return BookCellView(novel: model)
}
