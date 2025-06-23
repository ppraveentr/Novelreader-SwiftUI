//
//  NovelChapterModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import SwiftData

@Model
public class NovelChapterModel {
    @Attribute(.unique) public private(set) var identifier: String
    public var index: Int
    public var name: String
    public var content: String?
    @Relationship var novelPagination: NovelChapterPaginationModel

    public init(identifier: String, index: Int, name: String, content: String?, novel: NovelChapterPaginationModel) {
        self.identifier = identifier
        self.index = index
        self.name = name
        self.content = content
        self.novelPagination = novel
    }
}
