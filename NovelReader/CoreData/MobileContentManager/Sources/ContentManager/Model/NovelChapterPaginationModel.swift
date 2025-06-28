//
//  NovelChapterPaginationModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/27/25.
//

import SwiftData

@Model
public class NovelChapterPaginationModel {
    @Attribute(.unique) public private(set) var identifier: String
    @Relationship var novel: NovelModel?
    @Relationship(deleteRule: .cascade, inverse: \NovelChapterModel.novelPagination)
    public var chapters: [NovelChapterModel] = []
    public var pageCount: Int = 1
    public var currentPage: Int = 1

    public init(novel: NovelModel) {
        self.identifier = novel.identifier
        self.novel = novel
    }
}

