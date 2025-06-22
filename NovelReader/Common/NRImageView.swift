//
//  NRImageView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/18/25.
//

import SwiftUI

struct NRImageView: View {
    let imageUrl: URL?
    var body: some View {
        // Async Image downloads image from URL
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .empty:
                // Placeholder: gray rectangle while loading
                Color.gray
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            case .failure:
                // Error view: shows a fallback image or icon
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 120)
                    .foregroundColor(.gray)
                    .cornerRadius(8)
            @unknown default:
                EmptyView()
            }
        }
    }
}
