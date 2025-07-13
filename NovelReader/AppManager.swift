//
//  AppManager.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 2/15/25.
//

import ContentManager
import Foundation
import Theme
import SwiftData
import Combine
import SwiftUI

final class AppManager {
    private enum Environment: String {
        case production = "https://novelreader-nodejs.onrender.com/"
        case localhost = "http://localhost:3000/"
    }

    private enum Constants {
        static let themeJson = "Theme.json"
    }

    private var endPoint: Environment
    private var cancellables = Set<AnyCancellable>()
    let genreFetchError = PassthroughSubject<Error, Never>()

    static let shared = AppManager()
    let dbManger = ContentStore.contentManager

    private init() {
        self.endPoint = .localhost
        NovelServices.appBaseURL = endPoint.rawValue
    }

    func loadThemeModel(theme: String = Constants.themeJson) async {
        guard let lightTheme = try? Data.contentOfFile(theme) else { return }
        try? ThemesManager.setupApplicationTheme(lightTheme)
    }

    @MainActor
    static var localModelContainer: ModelContext? {
        Self.shared.dbManger.localContentManager?.container.mainContext
    }

    @MainActor
    static var serverModelContainer: ModelContext? {
        Self.shared.dbManger.contentManager?.container.mainContext
    }
}

// MARK: Service

extension AppManager {
    @MainActor
    func updateGenre(_ isLoadingOrHasError: Binding<Bool>? = nil) {
        isLoadingOrHasError?.wrappedValue = true
        guard let onDeviceModelContainer = Self.serverModelContainer else {
            let error = NSError(domain: "AppManager",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Model container not available"])
            genreFetchError.send(error)
            return
        }
        NovelServices.syncGenericPublisher(modelContext: onDeviceModelContainer)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.genreFetchError.send(error)
                    isLoadingOrHasError?.wrappedValue = true
                } else {
                    isLoadingOrHasError?.wrappedValue = false
                }
                self?.cancellables.removeAll()
            }, receiveValue: {
                // Do nothing
            })
            .store(in: &cancellables)
    }
}
