//
//  NovelChapterListService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/23/25.
//

import Foundation
import SwiftData
import Networking

class NovelChapterListService: RequestObject {
    typealias ResponseType = NovelChapterListResponse.Type

    var type: ReqeustType { .GET }
    var baseURL = "http://localhost:3000/"
    var path = "novel/chapter-list"

    var requestBody: Codable?
    var responseBody: Codable?
    var requestQuery: [URLQueryItem]?

    struct NovelChapterListResponse: ServiceModel {
        var response: ServiceChapterPaginationModel
    }
}

extension NovelChapterListService {
    @MainActor
    func refreshChapterList(_ novel: NovelModel, modelContext: ModelContext) async {
        do {
            let webService = WebService()
            let response: NovelChapterListResponse = try await webService.downloadData(self)
            let itemData = response.response
            guard !itemData.identifier.isEmpty || !itemData.chapters.isEmpty || itemData.identifier == novel.identifier else {
                debugPrint("No data received or failed to decode (NovelChapterListService) response.")
                return
            }
            DispatchQueue.main.async {
                novel.updateChapterPagination(itemData, context: modelContext)
                try? modelContext.save()
            }
        } catch {
            debugPrint("Error fetching data (NovelChapterListService)")
            debugPrint(error.localizedDescription)
        }
    }
}
