//
//  NovelModel.swift
//  ContentManager
//
//  Created by Praveen Prabhakar on 9/3/24.
//  Copyright (c) 2024 Praveen P. All rights reserved.
//

import Foundation
import SwiftData

@Model
public class NovelModel {
    @Attribute(.unique) public private(set) var identifier: String
    public var name: String
    public var novelDataId: String?
    public var author: String?
    public var artist: String?
    public var source: String?
    public var status: String?
    public var imageUrl: URL?
    public var coverImageUrl: URL?
    public var rating: String?
    public var lastUpdate: String?
    public var genres: [String]?
    public var views: String?
    public var summary: String?
    @Relationship(deleteRule: .cascade, inverse: \NovelChapterPaginationModel.novel)
    public var chapters: NovelChapterPaginationModel?
    public var lastChapter: String?

    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}

@Model
public class NovelChapterPaginationModel {
    @Attribute(.unique) public private(set) var identifier: String
    @Relationship var novel: NovelModel
    @Relationship(deleteRule: .cascade, inverse: \NovelChapterModel.novelPagination)
    public var chapters: [NovelChapterModel] = []
    public var pageCount: Int = 1
    public var currentPage: Int = 1

    public init(novel: NovelModel) {
        self.identifier = novel.identifier
        self.novel = novel
    }
}
