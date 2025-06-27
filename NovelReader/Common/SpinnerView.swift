//
//  SpinnerView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/23/25.
//

import SwiftUI

struct SpinnerView: View {
    var isShowing: Bool
    var body: some View {
        if isShowing {
            HStack {
                Spacer()
                ProgressView()
                    .controlSize(.large)
                Spacer()
            }
        }
    }
}
