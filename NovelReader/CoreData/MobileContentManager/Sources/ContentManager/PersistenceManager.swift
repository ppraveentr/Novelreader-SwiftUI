//
//  PersistenceManager.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 24/09/22.
//  Copyright (c) 2022 Praveen P. All rights reserved.
//

import SwiftData
import SwiftUI

@Observable
public class PersistenceManager {
    let dbName: String
    public var contentManager: SwiftModelContainer?

    public init(dbName: String) {
        self.dbName = dbName
        self.contentManager = try? SwiftModelContainer(dbName: dbName)
    }
}

public extension View {
    func persistenceManager(_ manager: PersistenceManager) -> some View {
        modifier(DBManagerModifier(manager: manager))
    }
}

private struct DBManagerModifier: ViewModifier {
    let manager: PersistenceManager

    func body(content: Content) -> some View {
        if let container = manager.contentManager?.container {
            content
                .modelContainer(container)
                .environment(manager)
        } else {
            content
                .environment(manager)
        }
    }
}
