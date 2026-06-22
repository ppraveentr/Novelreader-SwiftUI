//
//  LocalContainerProvider.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/27/25.
//

import Foundation
import SwiftData

public class LocalContainerProvider: ObservableObject {
    public let container: ModelContainer

    public init() throws {
        self.container = try Self.localModelContainer()
    }
}

// MARK: SwiftData Local ModelContainer

private extension LocalContainerProvider {
    static func localModelContainer() throws -> ModelContainer {
        do {
            // Local Model Config
            let localConfig = ModelSchemas.serviceConfiguration(allowsSaves: false)
            // All Schema
            let schema = Schema(ModelSchemas.serviceSchemas)
            // Model Container with allSchemas
            return try ModelContainer(for: schema, configurations: [localConfig])
        } catch {
            debugPrint(error.localizedDescription)
            throw NSError(domain: "Failed to configure LocalModel SwiftData container.", code: 500)
        }
    }
}
