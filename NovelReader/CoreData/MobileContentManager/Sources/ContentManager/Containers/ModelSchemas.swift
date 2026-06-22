//
//  ModelSchemas.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/20/25.
//

import Foundation
import SwiftData

enum ModelSchemas {
    static let schemasTypes: [any PersistentModel.Type] = [
        VisualContent.self,
        NovelListModel.self
    ]

    // MARK: CMS Content
    static let contentSchemas: [any PersistentModel.Type] = [
        VisualContent.self
    ]
    static var contentSchmeas: Schema {
        Schema(Self.contentSchemas)
    }

    static func contentConfiguration(_ storeURL: URL) -> ModelConfiguration {
        ModelConfiguration("cms", schema: contentSchmeas, url: storeURL, cloudKitDatabase: .none)
    }

    // MARK: Service Model

    static let serviceSchemas: [any PersistentModel.Type] = [
        NovelListModel.self
    ]

    static var serviceModelSchmeas: Schema {
        Schema(Self.serviceSchemas)
    }

    static func serviceConfiguration(allowsSaves: Bool = true) -> ModelConfiguration {
        if allowsSaves {
            ModelConfiguration("Server", schema: serviceModelSchmeas, allowsSave: true, cloudKitDatabase: .none)
        } else {
            ModelConfiguration("local", schema: serviceModelSchmeas, isStoredInMemoryOnly: false, cloudKitDatabase: .none)
        }
    }
}
