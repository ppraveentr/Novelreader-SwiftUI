//  AppStartupModifier.swift
//  NovelReader
//
//  Created to encapsulate app-wide loading and error handling logic.

import SwiftUI
import Combine

struct AppStartupModifier: ViewModifier {
    @Binding var isLoadingAppContent: Bool
    @State var alertError: GenericAlertError?
    @State private var cancellable: AnyCancellable?

//    var actionButtons: [AlertAction] {
//        let retryHandler: (ButtonRole) -> Void = { _ in
//            Task {
//                await fetchAppContent()
//            }
//        }
//        return [AlertAction(title: "Retry", role: .cancel, handler: retryHandler)]
//    }

    func body(content: Content) -> some View {
        content
            .task {
                // Listen for errors from genre fetch
//                cancellable = AppManager.shared.genreFetchError
//                    .receive(on: DispatchQueue.main)
//                    .sink { error in
//                        alertError = GenericAlertError(error: error, actions: actionButtons)
//                    }
                await AppManager.shared.loadThemeModel()
                await fetchAppContent()
                isLoadingAppContent = false
            }
//            .genericAlert($alertError)
    }

    @MainActor
    func fetchAppContent() async {
        AppManager.shared.updateGenre() // $isLoadingAppContent
    }
}

extension View {
    func appStartup(isLoadingAppContent: Binding<Bool>) -> some View {
        modifier(AppStartupModifier(isLoadingAppContent: isLoadingAppContent))
    }
}
