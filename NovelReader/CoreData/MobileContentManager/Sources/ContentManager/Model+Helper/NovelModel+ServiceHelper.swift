//
//  NovelModel+ServiceHelper.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/29/25.
//

import Foundation
import SwiftData

extension NovelModel {
    convenience init(service: ServiceNovelModel) {
        self.init(identifier: service.identifier, name: service.name)
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
