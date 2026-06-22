//
//  CoreDataContainer.swift
//  ContentManager
//
//  Created by Praveen Prabhakar on 9/2/24.
//  Copyright (c) 2024 Praveen P. All rights reserved.
//

import SwiftData

public class CoreDataContainer {
    public let dbName: String
//    public let contentManager: ContentManager

    public init(dbName: String, inMemory: Bool = false) throws {
        self.dbName = dbName
        // Setup Container
//        container = NSPersistentCloudKitContainer(name: dbName)
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (_, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible,
//                 due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
        // Setup DB
//        contentManager = try ContentManager(dbName: dbName)
    }
}
