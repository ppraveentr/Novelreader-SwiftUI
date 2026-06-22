//
//  ExpandableText.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 5/6/26.
//

import SwiftUI

struct ExpandableText: View {
    let text: String
    let lineLimit: Int
    var font: Font = .body

    @State private var isExpanded: Bool = false

    var body: some View {
        AlignedStack {
            Text(text)
                .font(font)
                .multilineTextAlignment(.leading)
                .lineLimit(isExpanded ? nil : lineLimit)
                .fixedSize(horizontal: false, vertical: true)
                .contentShape(Rectangle())
                .onTapGesture { withAnimation(.easeInOut) { isExpanded.toggle() } }

            Button(
                action: {
                    withAnimation(.easeInOut) {
                        isExpanded.toggle()
                    }
                },
                label: {
                    Image(systemName: "ellipsis.rectangle")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .contentTransition(.symbolEffect(.replace))
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.plain)
            .accessibilityLabel(isExpanded ? "Collapse" : "Expand")
        }
        .padding(.edgePadding)
    }
}

// MARK: Preview

#Preview {
    let value: String = {
        "<p>Starting over once more, he has entered this “living game” again in order to control his own fate.</p>"
        + "<p>This time, he will not be controlled by others.</p>"
        + "<p>Previously the Level 200 Sword King, he will rise to a higher peak in this life.</p>"
        + "<p>Methods to earn money! Dungeon conquering strategies! Legendary Quests! Equipment drop locations!"
        + " Undiscovered battle techniques!</p>"
        + "<p>Even the secrets Beta Testers were unknowledgeable of, he knows of them all.</p>"
        + "<p>Massive wars, life advancement, entering Godhood, sword reaching to the peak; a legend of a man"
        + " becoming a Sword God has begun.</p>"
        + "<p>Translator: Hellscythe</p>"
        + "<p>Editor: FluffyGoblyn (most of the time), MindLitUp (sometimes), Vampirecat (sometimes)</p>"
    }()

    ExpandableText(text: value, lineLimit: 2)
}
