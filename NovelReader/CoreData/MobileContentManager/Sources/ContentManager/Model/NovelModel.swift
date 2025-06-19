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
    public var author: String?
    public var artist: String?
    public var source: String?
    public var status: String?
    public var imageUrl: URL?
    public var coverImageUrl: URL?
    public var rating: String?
    public var lastUpdate: String?
    public var genres: [GenresModel]?
    public var views: String?
    public var summary: String?
    public var chapters: [NovelChapterModel]?
    public var lastChapter: String?

    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}
