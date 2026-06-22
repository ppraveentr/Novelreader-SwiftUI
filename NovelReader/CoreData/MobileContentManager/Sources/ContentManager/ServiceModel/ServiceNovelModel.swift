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
