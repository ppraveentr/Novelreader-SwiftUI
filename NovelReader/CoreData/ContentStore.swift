//
//  PersistenceManager.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 24/09/22.
//  Copyright (c) 2022 Praveen P. All rights reserved.
//

import ContentManager
import SwiftUI

enum ContentStore {
    static let dbName = "NovelReader.db"
    static var contentManager: PersistenceManager {
        PersistenceManager(dbName: dbName)
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
