//
//  BookTitleView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 2/16/25.
//

import ContentManager
import SwiftUI

struct BookTitleView: View {
    var novel: NovelModel
    var showLastChapter: Bool = true

    var body: some View {
        AlignedStack(.hStack(.top), spacing: EdgeInsets.contentPadding) {
            // Thumbnail image in the list row
            NRImageView(imageUrl: novel.imageUrl)
            // Novel Title
            AlignedStack {
                Text(novel.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                if let author = novel.author {
                    Text("By \(author)")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                // Show last chapter info in a smaller font
                if showLastChapter, let lastChapter = novel.lastChapter {
                    Text("Last: \(lastChapter)")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Spacer()
                }

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.edgePadding)
        .modifier(ConditionalGlassEffect(apply: showLastChapter))
    }
}

#Preview {
    let model = {
        let novel = NovelModel(identifier: "sds", name: "sds")
        novel.author = "Author"
        novel.lastChapter = "2165 Chapters"
        return novel
    }()
    return BookTitleView(novel: model)
}
