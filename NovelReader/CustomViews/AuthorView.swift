//
//  AuthorView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/23/25.
//

import SwiftUI

struct AuthorView: View {
    let author: String

    var body: some View {
        HStack(spacing: EdgeInsets.contentOffset) {
            Image(systemName: "person.fill")
                .foregroundColor(.secondary)
            Text("By \(author)")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
