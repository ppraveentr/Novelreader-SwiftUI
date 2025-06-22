//
//  ExpandableBookDetailCard.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/20/25.
//

import SwiftUI

struct ExpandableBookDetailCard: View {
    let author: String
    let genre: String
    let source: String
    let status: String

    @State private var expanded = false

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Book Information")
                    .font(.headline)
                Spacer()
                Button(
                    action: {
                        withAnimation {
                            expanded.toggle()
                        }
                    }, label: {
                        Image(systemName: expanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.blue)
                    })
            }

            if expanded {
                BookDetailCard(
                    author: author,
                    genre: genre,
                    source: source,
                    status: status
                )
                .transition(.opacity.combined(with: .opacity))
            }
        }
        .onTapGesture {
            withAnimation {
                expanded.toggle()
            }
        }
    }
}

struct BookDetailCard: View {
    let author: String
    let genre: String
    let source: String
    let status: String

    private var backgroundColor: Color {
        genre.contains("Romance") ? .pink.opacity(0.1) :
        genre.contains("Drama") ? .purple.opacity(0.1) :
            .gray.opacity(0.05)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DetailItem(icon: "person.fill", label: "Author", value: author)
            DetailItem(icon: "books.vertical.fill", label: "Genre", value: genre)
            DetailItem(icon: "globe", label: "Source", value: source)
            DetailItem(icon: status == "Completed" ? "checkmark.seal.fill" : "hourglass", label: "Status", value: status)
        }
        .padding(8)
//        .background(backgroundColor)
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct DetailItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading, spacing: 8) {
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
    ExpandableBookDetailCard(
        author: "Passion Honey, 百香蜜",
        genre: "Romance, Drama, Josei",
        source: "Qidian International",
        status: "Completed"
    )
}
