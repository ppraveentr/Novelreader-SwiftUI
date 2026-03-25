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
        GeometryReader { geometry in
            let isHorizontal = geometry.size.width > 500
            AlignedStack(isHorizontal ? .hStack : .vStack, spacing: isHorizontal ? 16 : 12) {
                DetailItem(itemType: .author, value: author)
                if let genre = genre {
                    DetailItem(itemType: .genre, value: genre.compactMap { $0 }.joined(separator: ", "))
                }
                DetailItem(itemType: .source, value: source)
            }
            .padding()
        }
    }
}

struct DetailItem: View {
    enum ViewType {
        case author, genre, source, status(State)

        enum State {
            case ongoing, completed
        }

        var icon: String {
            switch self {
            case .author:
                return "person.fill"
            case .genre:
                return "books.vertical.fill"
            case .source:
                return "globe"
            case let .status(state):
                return state == .ongoing ? "hourglass" : "checkmark.seal.fill"
            }
        }

        var label: String {
            switch self {
            case .author:
                return "Author"
            case .genre:
                return "Genre"
            case .source:
                return "Source"
            case .status:
                return "Status"
            }
        }
    }

    var itemType: ViewType
    let value: String
    var alignment: StackAlignment = .vStack

    var body: some View {
        AlignedStack(.hStack) {
            Image(systemName: itemType.icon)
                .foregroundColor(.accentColor)
            AlignedStack(alignment, spacing: EdgeInsets.contentOffset) {
                Text(itemType.label)
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(value)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
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
