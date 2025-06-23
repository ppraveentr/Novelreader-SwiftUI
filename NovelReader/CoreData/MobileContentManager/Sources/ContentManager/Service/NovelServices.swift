//
//  NovelServices.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/18/25.
//

import SwiftData
import Foundation

public enum NovelServices {
    @MainActor
    public static func syncNovelList(modelContext: ModelContext) async throws {
        let listService = NovelListService()
        await listService.refreshNovels(modelContext: modelContext)
    }

    @MainActor
    public static func syncNovelDetails(_ novel: NovelModel, modelContext: ModelContext) async throws {
        let detailService = NovelDetailService()
        let idQuery = URLQueryItem(name: "id", value: novel.identifier)
        detailService.requestQuery = [idQuery]
        await detailService.refreshNovelDetail(novel, modelContext: modelContext)
    }

    @MainActor
    public static func syncNovelChapterList(_ novel: NovelModel, page: Int, modelContext: ModelContext) async throws {
        let chapterListService = NovelChapterListService()
        let idQuery = URLQueryItem(name: "id", value: novel.identifier)
        let pageQuery = URLQueryItem(name: "page", value: "\(page)")
        chapterListService.requestQuery = [idQuery, pageQuery]
        await chapterListService.refreshChapterList(novel, modelContext: modelContext)
    }
}
