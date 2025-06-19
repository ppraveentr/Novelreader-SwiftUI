//
//  AppManager.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 2/15/25.
//

import Foundation
import Theme

final class AppManager {
    private enum Constants {
        static let themeJson = "Theme.json"
    }

    static let shared = AppManager()

    let dbManger = ContentStore.contentManager

    func loadThemeModel(theme: String = Constants.themeJson) async {
        guard let lightTheme = try? Data.contentOfFile(theme) else { return }
        try? ThemesManager.setupApplicationTheme(lightTheme)
    }
}
