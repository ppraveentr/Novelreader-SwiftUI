//
//  NovelServices.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/18/25.
//

import SwiftData

public enum NovelServices {
    @MainActor
    public static func syncNovelList(modelContext: ModelContext) async throws {
        let novrelListService = NovelListService()
        await novrelListService.refreshNovels(modelContext: modelContext)
    }
}
