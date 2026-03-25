//
//  StackAlignment.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/26/25.
//

import SwiftUI

enum StackAlignment {
    case vStack, hStack
    case vAlignedStack(alignment: HorizontalAlignment)
    case hAlignedStack(alignment: VerticalAlignment)
}

struct AlignedStack<Content: View>: View {
    let alignment: StackAlignment
    let spacing: CGFloat
    let content: () -> Content

    init(_ alignment: StackAlignment = .vStack, spacing: CGFloat = EdgeInsets.contentOffset,
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        switch alignment {
        case .vStack:
            VStack(alignment: .leading, spacing: spacing, content: content)
        case let .vAlignedStack(alignment):
            VStack(alignment: alignment, spacing: spacing, content: content)
        case .hStack:
            HStack(alignment: .top, spacing: spacing, content: content)
        case let .hAlignedStack(alignment):
            HStack(alignment: alignment, spacing: spacing, content: content)
        }
    }
}
