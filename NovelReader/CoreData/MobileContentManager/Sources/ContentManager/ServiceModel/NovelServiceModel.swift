//
//  ServiceModels.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import Foundation

struct NovelServiceModel: Codable {
    var identifier: String
    var name: String
    var author: String?
    var artist: String?
    var source: String?
    var status: String?
    var imageUrl: String?
    var coverImageUrl: String?
    var rating: String?
    var lastUpdate: String?
    var genres: [GenresServiceModel]?
    var views: String?
    var summary: String?
    var chapters: [NovelChapterServiceModel]?
    var lastChapter: String?
}

struct NovelChapterServiceModel: Codable {
    var identifier: String
    var name: String
    var content: String?

    init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}

struct GenresServiceModel: Codable {
    var identifier: String
    var name: String
}

extension NovelModel {
    convenience init(service: NovelServiceModel) {
        self.init(identifier: service.identifier, name: service.name)
        self.author = service.author
        self.artist = service.artist
        self.source = service.source
        self.status = service.status
        self.imageUrl = service.imageUrl.flatMap(URL.init(string:))
        self.coverImageUrl = service.coverImageUrl.flatMap(URL.init(string:))
        self.rating = service.rating
        self.lastUpdate = service.lastUpdate
        self.views = service.views
        self.summary = service.summary
        self.lastChapter = service.lastChapter
        // If you have mapping initializers for the genres and chapters:
        self.genres = service.genres?.map { GenresModel(identifier: $0.identifier, name: $0.name) }
        self.chapters = service.chapters?.map { NovelChapterModel(identifier: $0.identifier, name: $0.name, content: $0.content) }
    }
}
