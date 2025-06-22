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
    public var index: String
    public var name: String
    public var content: String?

    public init(identifier: String, index: String, name: String, content: String?) {
        self.identifier = identifier
        self.index = index
        self.name = name
        self.content = content
    }
}
