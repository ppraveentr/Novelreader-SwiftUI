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

final class AppManager {
    private enum Environment: String {
        case production = "https://novelreader-nodejs.onrender.com/"
        case localhost = "http://localhost:3000/"
    }

    private enum Constants {
        static let themeJson = "Theme.json"
    }

    static let shared = AppManager()
    private var endPoint: Environment
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
