//
//  ToolBarModifier.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/24/25.
//

import SwiftUI

public enum ToolBarModifierType {
    case profileButton(actionBlock: () -> Void)
}

struct ToolBarModifier: ViewModifier {
    fileprivate var type: ToolBarModifierType

    func body(content: Content) -> some View {
        content.toolbar {
            switch type {
            case let .profileButton(actionBlock):
                profileToobar(actionBlock)
            }
        }
    }

    @ToolbarContentBuilder func profileToobar(_ actionBlock: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                actionBlock()
            }, label: {
                Image(systemName: "person.circle")
                    .imageScale(.large)
            })
            .accessibilityLabel("User Profile")
        }
    }
}

extension View {
    /// Call this function to create tool bar
    /// - Parameters:
    ///   - style: Type ``ToolBarModifierType`` for the toolbar
    ///   - action: An action that needs to be exeuted on tap.
    /// - Returns: Modified ``View`` that incorporates the view modifier.
    func toolbarModifier(_ type: ToolBarModifierType) -> some View {
        return modifier(ToolBarModifier(type: type))
    }
}
