//
//  NRScrollView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 2/16/25.
//

import SwiftUI

struct NRScrollView<Content>: View where Content: View {
    private var content: () -> Content
    private let axes: Axis.Set

    init(_ axes: Axis.Set = .vertical, @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.content = content
    }

    var body: some View {
        ScrollView(axes, showsIndicators: true) {
            VStack {
                content()
            }
            .scrollTargetLayout()
        }
        .contentMargins(EdgeInsets.contentOffset)
        .scrollTargetBehavior(.viewAligned)
        .frame(maxWidth: .infinity)
    }
}
