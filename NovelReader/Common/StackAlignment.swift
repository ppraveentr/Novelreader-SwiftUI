//
//  StackAlignment.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/26/25.
//

import SwiftUI

enum StackAlignment {
    case vStack, hStack
}

struct AlignedStack<Content: View>: View {
    let alignment: StackAlignment
    let spacing: CGFloat
    let content: () -> Content

    init(alignment: StackAlignment = .vStack,
         spacing: CGFloat = EdgeInsets.contentOffset,
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        switch alignment {
        case .vStack:
            VStack(alignment: .leading, spacing: spacing, content: content)
        case .hStack:
            HStack(alignment: .top, spacing: spacing, content: content)
        }
    }
}
