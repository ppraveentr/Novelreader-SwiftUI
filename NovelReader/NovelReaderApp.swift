//
//  NovelReaderApp.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 24/09/22.
//  Copyright (c) 2022 Praveen P. All rights reserved.
//

import SwiftUI

@main
struct NovelReaderApp: App {
    @State var appManager = AppManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        await appManager.loadThemeModel()
                    }
                }
                .persistenceManager(appManager.dbManger)
        }
    }
}
