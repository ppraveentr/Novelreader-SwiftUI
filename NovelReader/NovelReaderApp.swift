//
//  NovelReaderApp.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 24/09/22.
//  Copyright (c) 2022 Praveen P. All rights reserved.
//

import SwiftUI
import Combine

@main
struct NovelReaderApp: App {
    @State var appManager = AppManager.shared
    @State private var isLoadingAppContent = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoadingAppContent {
                    SplashView()
                        .transition(.move(edge: .bottom))
                } else {
                    ContentView()
                }
            }
            .appStartup(isLoadingAppContent: $isLoadingAppContent)
            .persistenceManager(appManager.dbManger)
        }
    }
}
