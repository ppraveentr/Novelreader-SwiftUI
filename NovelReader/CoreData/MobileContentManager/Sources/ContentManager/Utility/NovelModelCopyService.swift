//
//  NovelModelCopyService.swift
//  NovelReader
//
//  Created by Assistant on 6/28/25.
//

import Foundation
import SwiftData

public enum NovelModelCopyService {

    /// Gets first novel with matching identifer from libary
    /// - Parameter identifier: The identifier of the novel to delete.
    public static func getNovel(identifier: String, context: ModelContext) -> NovelModel? {
        let fetchDescriptor = FetchDescriptor<NovelModel>(
            predicate: #Predicate { $0.identifier == identifier }
        )
        return try? context.fetch(fetchDescriptor).first
    }

    /// Deletes the NovelModel (and its chapters) from the server container, if available.
    /// - Parameter identifier: The identifier of the novel to delete.
    @discardableResult
    @MainActor
    public static func removeNovelWithChapters(identifier: String, serverContext: ModelContext) async throws {
        guard let localNovel = getNovel(identifier: identifier, context: serverContext) else { return }
        serverContext.delete(localNovel)
        try? serverContext.save()
    }

    /// Copies a NovelModel (and its chapters) from the local container to the server container, if both are available.
    /// - Parameter identifier: The identifier of the novel to copy.
    /// - Returns: The copied NovelModel in the server container, or nil if failed.
    @discardableResult
    @MainActor
    public static func copyNovelWithChapters(identifier: String,
                                             localContext: ModelContext,
                                             serverContext: ModelContext) async throws -> NovelModel? {
        guard let localNovel = try? getNovel(identifier: identifier, context: localContext) else {
            return nil
        }
        // Deep copy model
        let serverNovel = NovelModel(identifier: localNovel.identifier, name: localNovel.name)
        serverNovel.novelDataId = localNovel.novelDataId
        serverNovel.author = localNovel.author
        serverNovel.artist = localNovel.artist
        serverNovel.source = localNovel.source
        serverNovel.status = localNovel.status
        serverNovel.imageUrl = localNovel.imageUrl
        serverNovel.coverImageUrl = localNovel.coverImageUrl
        serverNovel.rating = localNovel.rating
        serverNovel.lastUpdate = localNovel.lastUpdate
        serverNovel.genres = localNovel.genres
        serverNovel.views = localNovel.views
        serverNovel.summary = localNovel.summary
        serverNovel.lastChapter = localNovel.lastChapter
        serverNovel.isFavorite = localNovel.isFavorite
        // Deep copy chapters (if present)
        if let chapters = localNovel.chapters {
            let copiedChapters = try await copyChapters(pagination: chapters,
                                                        newNovel: serverNovel,
                                                        serverContext: serverContext)
            serverNovel.chapters = copiedChapters
        }
        serverContext.insert(serverNovel)
        try serverContext.save()
        return serverNovel
    }

    private static func copyChapters(pagination: NovelChapterPaginationModel,
                                     newNovel: NovelModel,
                                     serverContext: ModelContext) async throws -> NovelChapterPaginationModel {
        let newPagination = NovelChapterPaginationModel(novel: newNovel)
        newPagination.currentPage = pagination.currentPage
        newPagination.pageCount = pagination.pageCount
        // Copy each chapter
        for chapter in pagination.chapters {
            let newChapter = NovelChapterModel(
                identifier: chapter.identifier,
                index: chapter.index,
                name: chapter.name,
                content: chapter.content,
                novel: newPagination
            )
            newPagination.chapters.append(newChapter)
        }
        return newPagination
    }
}
