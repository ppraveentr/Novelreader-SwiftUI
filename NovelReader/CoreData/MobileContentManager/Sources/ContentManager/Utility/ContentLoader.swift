//
//  ContentLoader.swift
//  ContentManager
//
//  Created by Praveen Prabhakar on 9/6/24.
//

import Foundation

// MARK: Preload the data

enum ContentLoader {
    static func preloadDBData(_ dbName: String) throws -> URL {
        guard let sourceURL = ContentBundle.url(forResource: dbName, withExtension: nil) else {
            debugPrint("DB missing, Could not preload data")
            throw NSError(domain: "DB missing, Could not preload data", code: 500)
        }
        return try Self.preloadDBData(sourceURL, name: dbName)
    }

    static func preloadDBData(_ sourceURL: URL, name: String) throws -> URL {
        //        let destURL = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/\(name)")
        let destURL = URL.documentsDirectory.appending(path: name)
        let fileExits = FileManager.default.fileExists(atPath: destURL.relativePath)
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded") && fileExits
        guard !isPreloaded else {
            debugPrint("DB PreLoaded")
            return destURL
        }
        debugPrint("Preloading data for the first time")
        do {
            try FileManager.default.copyItem(at: sourceURL, to: destURL)
        } catch {
            debugPrint("Copy Failed: \(error.localizedDescription), Could not preload data")
            throw error
        }
        defaults.set(true, forKey: "isPreloaded")
        debugPrint("Success: Preloading data for the first time: \(destURL.absoluteString)")
        return destURL
    }
}
