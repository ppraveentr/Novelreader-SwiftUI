//
//  ServiceNovelListModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 5/14/26.
//

import Foundation
import SwiftData

public enum NovelListType: String, Codable {
    case completed, favorites
}

struct ServiceNovelListModel: Codable {
    var pageCount: Int?
    var currentPage: Int?
    var novels: [ServiceNovelModel]
    var listType: NovelListType = .completed
}
