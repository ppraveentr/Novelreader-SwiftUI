//
//  RatingView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/20/25.
//

import SwiftUI

struct RatingView: View {
    var rating: String?
    var reviews: String?

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                if let rating = rating, let value = Double(rating)?.rounded() {
                    ForEach(1...10, id: \.self) { index in
                        Image(systemName: index <= Int(value) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    Text(rating)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            if let reviews = reviews {
                let count = formatReviewCount(reviews)
                Text("(\(formatReviewCount(count)) reviews)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    func formatReviewCount(_ count: String) -> String {
        let count: Int = Int(count) ?? 0
        switch count {
        case 1_000_000...:
            return String(format: "%.1fM", Double(count) / 1_000_000)
        case 1_000...:
            return String(format: "%.1fK", Double(count) / 1_000)
        default:
            return "\(count)"
        }
    }
}
