//
//  ServiceNovelModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import Foundation
import SwiftData

struct ServiceNovelModel: Codable {
    var identifier: String
    var novelDataId: String?
    var name: String
    var author: String?
    var artist: String?
    var source: String?
    var status: String?
    var imageUrl: String?
    var coverImageUrl: String?
    var rating: String?
    var lastUpdate: String?
    var genres: [String]?
    var views: String?
    var summary: String?
    var chapters: ServiceChapterPaginationModel?
    var lastChapter: String?
    var pageCount: Int?
}

struct ServiceChapterPaginationModel: Codable {
    var identifier: String
    var chapters: [ServiceChapterModel] = []
    var pageCount: Int = 1
    var currentPage: Int = 1
}

struct ServiceChapterModel: Codable {
    var identifier: String
    var index: Int
    var name: String
    var content: String?

    init(identifier: String, index: Int, name: String) {
        self.identifier = identifier
        self.index = index
        self.name = name
    }
}

struct ServiceGenresModel: Codable {
    var identifier: String
    var name: String
}

/*

extension SearchNovelModel {
    convenience init(service: ServiceNovelModel) {
        self.init(identifier: service.identifier, name: service.name)
    }

    func update(service: ServiceNovelModel, context: ModelContext) {
        if let imageUrl = service.imageUrl.flatMap(URL.init(string:)) {
            self.imageUrl = imageUrl
        }
        if let lastChapter = service.lastChapter {
            self.lastChapter = lastChapter
        }
    }
}

*/

extension NovelModel {
    convenience init(service: ServiceNovelModel, name: String? = nil) {
        self.init(identifier: service.identifier, name: service.name + " - \(name ?? "")")
    }

    func update(service: ServiceNovelModel, context: ModelContext) {
        updateBasicProperties(from: service)
        updateBookInfo(from: service)
        updateGenres(from: service)
        updateChapters(from: service, context: context)
    }

    private func updateBookInfo(from service: ServiceNovelModel) {
        if let author = service.author {
            self.author = author
        }
        if let artist = service.artist {
            self.artist = artist
        }
        if let source = service.source {
            self.source = source
        }
        if let status = service.status {
            self.status = status
        }
        if let lastUpdate = service.lastUpdate {
            self.lastUpdate = lastUpdate
        }
    }

    private func updateBasicProperties(from service: ServiceNovelModel) {
        if let imageUrl = service.imageUrl.flatMap(URL.init(string:)) {
            self.imageUrl = imageUrl
        }
        if let coverImageUrl = service.coverImageUrl.flatMap(URL.init(string:)) {
            self.coverImageUrl = coverImageUrl
        }
        if let rating = service.rating {
            self.rating = rating
        }
        if let views = service.views {
            self.views = views
        }
        if let summary = service.summary {
            self.summary = summary
        }
        if let lastChapter = service.lastChapter {
            self.lastChapter = lastChapter
        }
    }

    private func updateGenres(from service: ServiceNovelModel) {
        if let genres = service.genres {
            self.genres = genres
        }
    }

    private func updateChapters(from service: ServiceNovelModel, context: ModelContext) {
        if let chapters = service.chapters {
            updateChapterPagination(chapters, context: context)
            self.chapters?.update(service: chapters, context: context)
        }
    }

    func updateChapterPagination(_ with: ServiceChapterPaginationModel, context: ModelContext) {
        let identifier = self.identifier
        let descriptor = FetchDescriptor<NovelChapterPaginationModel>(
            predicate: #Predicate { $0.identifier == identifier && $0.novel?.identifier == identifier }
        )
        // Fetch exiting Chapter model
        let paginator = (try? context.fetch(descriptor).first) ?? NovelChapterPaginationModel(novel: self)
        self.chapters = paginator
        // Update existing chapter
        paginator.currentPage = with.currentPage
        paginator.pageCount = with.pageCount
        // Update Chapter list
        paginator.update(service: with, context: context)
    }
}

extension NovelChapterPaginationModel {
    func update(service: ServiceChapterPaginationModel, context: ModelContext) {
        // Delete all existing chapters to avoid orphaned relationships
//        for chapter in self.chapters {
//            context.delete(chapter)
//        }
        let newCh = service.chapters.map { chap in
            insertChapter(chap, context: context)
        }
        self.chapters.append(contentsOf: newCh)
    }

    private func insertChapter(_ model: ServiceChapterModel, context: ModelContext) -> NovelChapterModel {
        let identifier = identifier
        let descriptor = FetchDescriptor<NovelChapterModel>(
            predicate: #Predicate { $0.identifier == model.identifier && $0.novelPagination?.identifier == identifier }
        )

        if let existing = try? context.fetch(descriptor).first {
            // Update existing chapter
            existing.name = model.name
            existing.index = model.index
            existing.content = model.content
            return existing
        } else {
            // Insert new chapter
            let newChapter = NovelChapterModel(
                identifier: model.identifier,
                index: model.index,
                name: model.name,
                content: model.content,
                novel: self
            )
            return newChapter
        }
    }
}
