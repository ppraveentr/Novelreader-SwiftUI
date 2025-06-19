//
//  NovelView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 2/16/25.
//

import ContentManager
import SwiftUI

struct NovelView: View {
    var novel: NovelModel

    var body: some View {
        VStack {
            HStack {
                // Thumbnail image in the list row
                NRImageView(imageUrl: novel.coverImageUrl)
                // Novel information: title and author are shown in the list row
                VStack(alignment: .leading, spacing: 4) {
                    Text(novel.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    // Author
                    if let author = novel.author {
                        Text("By \(author)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                // Optional: Show last chapter info in a smaller font
                if let lastChapter = novel.lastChapter {
                    Text(lastChapter)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.edgePadding)

            // Divider to separate rows
            Divider()
                .padding(.edgePadding)
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
    return NovelView(novel: model)
}
