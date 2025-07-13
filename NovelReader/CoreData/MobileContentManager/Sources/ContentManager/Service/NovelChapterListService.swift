//
//  NovelChapterListService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/23/25.
//

import Combine
import Foundation
import SwiftData
import Networking

class NovelChapterListService: BaseNovelRequest {
    typealias ResponseType = NovelChapterListResponse.Type

    var type: ReqeustType { .GET }
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
    func fetchChapterListPublisher(_ novel: NovelModel, modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        WebService.downloadDataPublisher(self)
            .tryMap { (response: NovelChapterListResponse) in
                let itemData = response.response
                guard !itemData.identifier.isEmpty || !itemData.chapters.isEmpty || itemData.identifier == novel.identifier else {
                    debugPrint("No data received or failed to decode (NovelChapterListService) response.")
                    throw NetworkError.failedToDecodeResponse
                }
                return itemData
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { itemData in
                novel.updateChapterPagination(itemData, context: modelContext)
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
