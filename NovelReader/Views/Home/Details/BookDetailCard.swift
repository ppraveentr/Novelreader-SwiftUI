//
//  ExpandableBookDetailCard.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/20/25.
//

import SwiftUI

struct BookDetailCard: View {
    let author: String
    let genre: [String]?
    let source: String
    let status: String

    var body: some View {
        AlignedStack {
            DetailItem(icon: "person.fill", label: "Author", value: author)
            Spacer()
            if let genre = genre {
                DetailItem(icon: "books.vertical.fill", label: "Genre", value: genre.compactMap { $0 }.joined(separator: ", "))
                Spacer()
            }
            DetailItem(icon: "globe", label: "Source", value: source)
        }
    }
}

struct DetailItem: View {
    let icon, label, value: String
    var alignment: StackAlignment = .vStack

    var body: some View {
        AlignedStack(.hStack) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            AlignedStack(alignment, spacing: EdgeInsets.contentOffset) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(value)
                    .fontWeight(.medium)
            }
        }
    }
}

#Preview {
    BookDetailCard(
        author: "Passion Honey, 百香蜜",
        genre: ["Romance", "Drama", "Josei"],
        source: "Qidian International",
        status: "Completed"
    )
}
