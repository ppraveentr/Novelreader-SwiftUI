//
//  ProfileImageCustomizer.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/21/25.
//

import SwiftUI
import ImagePlayground

@available(iOS 18.1, *)
struct ProfileImageCustomizer: View {
    // Environment variable to check if Image Playground features are supported
    @Environment(\.supportsImagePlayground) var supportsImagePlayground

    // State to control presentation of the Image Playground sheet
    @State private var showImagePlaygroundSheet = false
    // State to store the generated profile image
    @State private var profileImage: UIImage?

    var body: some View {
        VStack(spacing: 20) {
            // Display the current profile image or a placeholder if none selected
            if let image = profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                    .shadow(radius: 5)
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 200)
                    .overlay(Text("No Image")
                        .foregroundColor(.white)
                        .font(.headline))
            }

            // Button to launch Image Playground for customization
            Button(action: {
                showImagePlaygroundSheet.toggle()
            }, label: {
                Text("Customize Profile Image")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            })
            .disabled(!supportsImagePlayground)
            .padding(.horizontal)
        }
        .padding()
        .imagePlaygroundSheet(isPresented: $showImagePlaygroundSheet,
                              concept: "A stunning portrait with an artistic flair, perfect for a profile image.") { url in
            // Print url
            debugPrint(url)
        }
    }
}
