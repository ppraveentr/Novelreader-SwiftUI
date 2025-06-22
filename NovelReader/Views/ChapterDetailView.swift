//
//  ChapterDetailView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/22/25.
//

import ContentManager
import SwiftUI

struct ChapterDetailView: View {
    let chapter: Chapter

    var body: some View {
        VStack(spacing: 16) {
            Text(chapter.title)
                .font(.largeTitle)
                .bold()
            Text("Chapter number: \(chapter.chapterNumber)")
                .font(.title2)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}
