//
//  NovelChapterPaginationModel+Helper.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/29/25.
//

import SwiftData
import Foundation

extension NovelChapterPaginationModel {
    func update(service: ServiceChapterPaginationModel, context: ModelContext) {
        // Delete all existing chapters to avoid orphaned relationships
//        service.chapters.removeAll()
        let newCh = service.chapters.map { chap in
            insertChapter(chap, context: context)
        }
        self.chapters.append(contentsOf: newCh)
    }

    private func insertChapter(_ model: ServiceChapterModel, context: ModelContext) -> NovelChapterModel {
        let identifier = identifier
        let descriptor = FetchDescriptor<NovelChapterModel>(
            predicate: #Predicate { $0.identifier == model.identifier && $0.novelPagination?.identifier == identifier }
        )

        if let existing = try? context.fetch(descriptor).first {
            // Update existing chapter
            existing.name = model.name
            existing.index = model.index
            existing.content = model.content
            return existing
        } else {
            // Insert new chapter
            let newChapter = NovelChapterModel(
                identifier: model.identifier,
                index: model.index,
                name: model.name,
                content: model.content,
                novel: self
            )
            return newChapter
        }
    }
}
