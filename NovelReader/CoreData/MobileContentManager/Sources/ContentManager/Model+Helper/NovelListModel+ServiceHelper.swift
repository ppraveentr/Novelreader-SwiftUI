import Foundation
import SwiftData

public extension NovelListModel {
    static func fetchDescriptor(_ type: NovelListType) -> FetchDescriptor<NovelListModel> {
        FetchDescriptor<NovelListModel>(
            predicate: #Predicate { $0.identifier == type.rawValue }
        )
    }

    static func fetchModel(for type: NovelListType, modelContext: ModelContext) -> NovelListModel {
        let fetchDescriptor = Self.fetchDescriptor(type)
        if let existing = try? modelContext.fetch(fetchDescriptor).first {
            return existing
        } else {
            // Create a new one with identifier based on list type
            let newModel = NovelListModel(identifier: type.rawValue)
            modelContext.insert(newModel)
            return newModel
        }
    }
}

extension NovelListModel {
    // Updates this list from a service list and persists/upserts all novels into the provided context.
    // - Parameters:
    //   - service: The service response model representing the list
    //   - context: The SwiftData model context to use for upserting
    func update(from service: ServiceNovelListModel, context: ModelContext) {
        // Map service novels to NovelModel using your existing NovelModel helpers or a direct init
        let models = service.novels.map { NovelModel(service: $0) }

        // Assign updated values
        self.novels = models
        // If your NovelListModel has non-optional Ints, unwrap optionals safely
        self.pageCount = service.pageCount ?? self.pageCount
        self.currentPage = service.currentPage ?? self.currentPage
        // Only set properties that exist on NovelListModel; remove listType if it doesn't exist
    }
}
