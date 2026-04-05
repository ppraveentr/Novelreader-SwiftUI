//
//  StackAlignment.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/26/25.
//

import SwiftUI

enum StackAlignment {
    case vStack(_ alignment: HorizontalAlignment = .leading)
    case hStack(_ alignment: VerticalAlignment = .top)
}

struct AlignedStack<Content: View>: View {
    let alignment: StackAlignment
    let spacing: CGFloat
    let content: () -> Content

    init(_ alignment: StackAlignment = .vStack(), spacing: CGFloat = EdgeInsets.contentOffset,
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        switch alignment {
        case let .vStack(alignment):
            VStack(alignment: alignment, spacing: spacing, content: content)
        case let .hStack(alignment):
            HStack(alignment: alignment, spacing: spacing, content: content)
        }
    }
}
