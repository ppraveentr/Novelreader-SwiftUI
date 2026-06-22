//  GenericAlertModifier.swift
//  NovelReader
//
//  Created for reusability.

import SwiftUI
import Networking

/// A protocol for defining types that can be shown in a generic alert.
protocol AlertPresentable: Identifiable {
    var title: String { get }
    var message: String { get }
    var actions: [AlertAction] { get }
}

/// A struct that represents an action in an alert.
struct AlertAction: Identifiable {
    let id = UUID()
    let title: String
    let role: ButtonRole
    let handler: ((_ action: ButtonRole) -> Void)?
}

/// A generic error type conforming to AlertPresentable for demonstration.
struct GenericAlertError: AlertPresentable {
    let id = UUID()
    let error: Error
    @State var titleString: String?
    @State var errorMessage: String?
    @State var actions: [AlertAction] = []

    var title: String { titleString ?? "Error" }
    var message: String {
        switch error {
        case let error as NetworkError:
            return error.stringValue
        default:
            return errorMessage ?? error.localizedDescription
        }
    }
}

/// A view modifier for showing alerts from any AlertPresentable type.
struct GenericAlertModifier<T: AlertPresentable>: ViewModifier {
    @Binding var alertItem: T?

    func body(content: Content) -> some View {
        content
            .alert(
                alertItem?.title ?? "",
                isPresented: Binding(
                    get: { alertItem != nil },
                    set: { if !$0 { alertItem = nil } }
                ),
                actions: {
                    if let alert = alertItem {
                        ForEach(alert.actions, id: \.id) { action in
                            Button(action.title, role: action.role) {
                                action.handler?(action.role)
                                alertItem = nil
                            }
                        }
                    }
                },
                message: {
                    Text(alertItem?.message ?? "")
                }
            )
    }
}

extension View {
    func genericAlert<T: AlertPresentable>(_ item: Binding<T?>) -> some View {
        modifier(GenericAlertModifier(alertItem: item))
    }
}
