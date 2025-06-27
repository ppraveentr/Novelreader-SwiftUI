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
    private let onBottomReached: (() -> Void)?
    @State private var isAtBottom = false

    init(_ axes: Axis.Set = .vertical, onBottomReached: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.onBottomReached = onBottomReached
        self.content = content
    }

    var body: some View {
        ScrollViewReader { _ in
            ScrollView(axes, showsIndicators: true) {
                VStack {
                    content()
                    if onBottomReached != nil {
                        // Marker at the bottom
                        GeometryReader { geo in
                            Color.clear
                                .frame(height: 1)
                                .onAppear { isAtBottom = true }
                                .onDisappear { isAtBottom = false }
                                .onChange(of: geo.frame(in: .global).maxY) { _, newY in
                                    let screenHeight = UIScreen.main.bounds.height
                                    let atBottom = newY < screenHeight - 100
                                    // Only fire on transition from not-at-bottom to at-bottom
                                    if atBottom && !isAtBottom {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            onBottomReached?()
                                        }
                                    }
                                    isAtBottom = atBottom
                                }
                        }
                        .frame(height: 1)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(EdgeInsets.contentOffset)
            .scrollTargetBehavior(.viewAligned)
            .frame(maxWidth: .infinity)
        }
    }
}
