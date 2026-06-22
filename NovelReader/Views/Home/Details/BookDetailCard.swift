//
//  ExpandableBookDetailCard.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/20/25.
//

import SwiftUI

struct BookDetailCard: View {
    let source, status: String?
    var rating: RatingModel?

    var body: some View {
        AlignedStack(.hStack(), spacing: 16) {
            if let status {
                DetailItem(itemType: .status(.init(rawValue: status) ?? .ongoing), value: status)
            }
            if let source {
                DetailItem(itemType: .source, value: source)
            }
            if let rating {
                DetailItem(itemType: .rating(rating: rating), value: rating.formatReviewCount)
            }
        }
    }
}

struct RatingModel {
    var rating: Double
    var maxRating = 5.0
    var maxPossibleRating = 10.0
    var reviews: String?

    var shownRating: Double {
        (rating / maxPossibleRating) * Double(maxRating)
    }

    var formatReviewCount: String {
        guard let reviews, let count = Int(reviews) else { return "" }
        switch count {
        case 1_000_000...:
            return String(format: "%.1fM", Double(count) / 1_000_000)
        case 1_000...:
            return String(format: "%.1fK", Double(count) / 1_000)
        default:
            return "\(count)"
        }
    }

    func starImage() -> AnyView {
        AnyView(
            HStack(spacing: 1) {
                ForEach(1...Int(maxRating), id: \.self) { index in
                    stars(Double(index), shownRating: shownRating)
                }
            }
        )
    }

    private func stars(_ starValue: Double, shownRating: Double) -> some View {
        var imageName = "star"
        if shownRating >= starValue {
            imageName = "star.fill"
        } else if shownRating >= starValue - 0.75, shownRating < starValue - 0.25 {
            imageName = "star.leadinghalf.filled"
        }
        return Image(systemName: imageName)
            .foregroundColor(.yellow)
    }
}

struct DetailItem: View {
    enum ViewType {
        case genre, source, status(State)
        case rating(rating: RatingModel)

        enum State: String {
            case ongoing, completed
        }

        func imageView(_ icon: String) -> AnyView {
            AnyView(
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
            )
        }

        var icon: AnyView {
            switch self {
            case .genre:
                imageView("books.vertical.fill")
            case .source:
                imageView("globe")
            case let .status(state):
                imageView(state == .ongoing ? "hourglass" : "checkmark.seal.fill")
            case let .rating(rating):
                rating.starImage()
            }
        }

        var label: String {
            switch self {
            case .genre:
                "Genre"
            case .source:
                "Source"
            case .status:
                "Status"
            case let .rating(rating):
                "Rating: \(rating.rating.rounded(.toNearestOrEven))"
            }
        }
    }

    var itemType: ViewType
    let value: String
    var alignment: StackAlignment = .vStack()

    var body: some View {
        Group {
            AlignedStack(.vStack(.center), spacing: EdgeInsets.contentPadding) {
                Text(itemType.label)
                    .font(.headline)
                    .foregroundColor(.secondary)
                itemType.icon
                Text(value)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxHeight: .greatestFiniteMagnitude, alignment: .top)
        }
        .padding(.edgeSidePadding)
    }
}

#Preview {
    BookDetailCard(
        source: "Qidian International",
        status: "Completed",
        rating: RatingModel(rating: 5, reviews: "21212")
    )
}
