//
//  RatingView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/20/25.
//

import SwiftUI

struct RatingView: View {

    var rating: Double
    var maxRating = 5.0
    var maxPossibleRating = 10.0
    var reviews: String?

    private var shownRating: Double {
        (rating / maxPossibleRating) * Double(maxRating)
    }

    var body: some View {
        AlignedStack {
            Group {
                AlignedStack(.hStack(), spacing: EdgeInsets.contentPadding) {
                    ForEach(1...Int(maxRating), id: \.self) { index in
                        image(Double(index), shownRating: shownRating)
                    }
                    Text(String(format: "%.1f", shownRating))
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                if let reviews = reviews {
                    let count = formatReviewCount(reviews)
                    Text("\(count) reviews")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.edgeSidePadding)
    }

    private func image(_ starValue: Double, shownRating: Double) -> some View {
        var imageName = "star"
        if shownRating >= starValue {
            imageName = "star.fill"
        } else if shownRating >= starValue - 0.75, shownRating < starValue - 0.25 {
            imageName = "star.leadinghalf.filled"
        }
        return Image(systemName: imageName)
            .foregroundColor(.yellow)
    }

    private func formatReviewCount(_ count: String) -> String {
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
