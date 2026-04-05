//
//  BannerView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/27/25.
//

import SwiftUI

struct BannerView: View {
    enum MessageType {
        case error(Error?)
        case generic(String)
        case success(String)

        var textColor: Color {
            switch self {
            case .error, .generic:
                .white
            case .success:
                .black
            }
        }

        var color: Color {
            switch self {
            case .error:
                .red
            case .generic:
                .black
            case .success:
                .green
            }
        }

        var message: String? {
            switch self {
            case .error(let error):
                if let error {
                    return "Error: \(error.localizedDescription)"
                }
                return nil
            case .generic(let message):
                return message
            case .success(let message):
                return message
            }
        }
    }

    let message: String
    let messageType: MessageType
    let action: () -> Void

    var body: some View {
        AlignedStack {
            AlignedStack(.hStack(.center)) {
                Text(message)
                    .padding()
                    .frame(maxWidth: .infinity)
                Button(action: action) {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .padding(.trailing)
                }
            }
            .foregroundColor(messageType.textColor)
        }
        .background(messageType.color.opacity(0.5))
        .cornerRadius(8)
        .shadow(color: messageType.color, radius: 4)
        .padding([.horizontal, .top])
    }
}

extension View {
    func bannerOverlay(_ messageType: BannerView.MessageType, actionBlock: @escaping () -> Void) -> some View {
        self.overlay(
            Group {
                if let message = messageType.message {
                    BannerView(message: message,
                               messageType: messageType,
                               action: actionBlock)
                }
            }, alignment: .top
        )
    }
}
