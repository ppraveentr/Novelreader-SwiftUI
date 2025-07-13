//
//  ServiceChapterPaginationModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/29/25.
//

import Foundation

struct ServiceChapterPaginationModel: Codable {
    var identifier: String
    var chapters: [ServiceChapterModel] = []
    var pageCount: Int = 1
    var currentPage: Int = 1
}
