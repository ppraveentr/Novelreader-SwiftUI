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
    @State private var debounceWorkItem: DispatchWorkItem?

    /// NRScrollView is a flexible scroll container for SwiftUI.
    ///
    /// You can provide any layout as the content, such as a ForEach in a VStack/LazyVStack for lists, or a LazyVGrid for grids/collections.
    /// This allows the caller to adapt the layout for iPhone (list) or iPad (grid) based on device or trait environment.
    /// The `axes` parameter controls the scrolling direction, and `content` is a `@ViewBuilder` closure.
    /// The bottom marker uses the container height to detect when the bottom is reached.
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
                        geomentryReader()
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(EdgeInsets.contentOffset)
            .scrollTargetBehavior(.viewAligned)
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    func geomentryReader() -> some View {
        // Marker at the bottom
        GeometryReader { geo in
            Color.clear
                .frame(height: 1)
                .onAppear { isAtBottom = true }
                .onDisappear { isAtBottom = false }
                .onChange(of: geo.frame(in: .global).maxY) { _, newY in
                    update(newY, containerHeight: geo.frame(in: .global).height)
                }
        }
        .frame(height: 1)
    }

    func update(_ newY: CGFloat, containerHeight: CGFloat) {
        let screenHeight = containerHeight
        let atBottom = newY < screenHeight - 100
        if atBottom && !isAtBottom {
            debounceWorkItem?.cancel()
            let workItem = DispatchWorkItem {
                onBottomReached?()
            }
            debounceWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
        }
        isAtBottom = atBottom
    }
}
