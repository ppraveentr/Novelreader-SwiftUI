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
    @State private var scrollPosition: UUID?
    @State private var didFireBottom = false
    private let bottomID = UUID()

    /// NRScrollView is a flexible scroll container for SwiftUI.
    ///
    /// Now uses the modern scroll position API (`.scrollPosition(id:)`) to detect when the user reaches the bottom.
    /// Add your content as usual. Optionally provide `onBottomReached`.
    init(_ axes: Axis.Set = .vertical, onBottomReached: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.onBottomReached = onBottomReached
        self.content = content
    }

    var body: some View {
        ScrollViewReader { _ in
            ScrollView(axes, showsIndicators: true) {
                VStack(alignment: .center, spacing: 0) {
                    content()
                    if onBottomReached != nil {
                        // Invisible bottom marker
                        Color.clear.frame(height: 1).id(bottomID)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(EdgeInsets.contentOffset)
            .scrollTargetBehavior(.viewAligned)
            .frame(maxWidth: .infinity)
            .scrollPosition(id: $scrollPosition)
            .onChange(of: scrollPosition) { _, newValue in
                // Fire only once per reach to bottom; reset when we move away
                if newValue == bottomID {
                    if didFireBottom == false {
                        didFireBottom = true
                        onBottomReached?()
                    }
                } else {
                    // Moved away from bottom; allow future triggers
                    if didFireBottom {
                        didFireBottom = false
                    }
                }
            }
        }
    }
}
