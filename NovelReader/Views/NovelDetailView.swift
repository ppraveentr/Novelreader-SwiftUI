//
//  NovelDetailView.swift
//  NovelReader
//
//  Created by Praveen P on 3/3/24.
//  Copyright (c) 2024 Praveen P. All rights reserved.
//

import ContentManager
import SwiftUI

struct NovelDetailView: View {
    let novel: NovelModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Thumbnail image in the list row
                NRImageView(imageUrl: novel.coverImageUrl)
                Text(novel.name)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                if let author = novel.author {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                        Text(author)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Divider()
                if let lastChapter = novel.lastChapter {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last Chapter")
                            .font(.headline)
                        Text(lastChapter)
                            .font(.body)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer()
            }
            .padding()
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
    NovelDetailView(novel: model)
}
