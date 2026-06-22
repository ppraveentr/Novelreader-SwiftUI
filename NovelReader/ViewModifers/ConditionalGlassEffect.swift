//
//  ConditionalGlassEffect.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 5/6/26.
//

import SwiftUI

struct ConditionalGlassEffect: ViewModifier {
    var apply: Bool = true
    func body(content: Content) -> some View {
        if apply {
            content.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
        } else {
            content
        }
    }
}
