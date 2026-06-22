//
//  NovelListModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 5/16/26.
//

import Foundation
import SwiftData

@Model
public class NovelListModel {
    @Attribute(.unique) public private(set) var identifier: String
    public var currentPage: Int = 0
    public var pageCount: Int = 1
    public var novels: [NovelModel]?

    public init(identifier: String, currentPage: Int = 0, pageCount: Int = 1) {
        self.identifier = identifier
        self.currentPage = currentPage
        self.pageCount = pageCount
    }
}
