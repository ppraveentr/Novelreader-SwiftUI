//
//  ServiceChapterModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/29/25.
//

import Foundation

struct ServiceChapterModel: Codable {
    var identifier: String
    var index: Int
    var name: String
    var content: String?

    init(identifier: String, index: Int, name: String) {
        self.identifier = identifier
        self.index = index
        self.name = name
    }
}
