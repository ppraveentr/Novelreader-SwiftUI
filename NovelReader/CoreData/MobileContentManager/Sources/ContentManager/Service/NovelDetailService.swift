//
//  NovelDetailService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/22/25.
//

import Foundation
import SwiftData
import Networking
import Combine

class NovelDetailService: BaseNovelRequest {
    typealias ResponseType = NovelDetailResponse.Type

    var type: ReqeustType { .GET }
    var path = "novel/novel-details"

    var requestBody: Codable?
    var responseBody: Codable?
    var requestQuery: [URLQueryItem]?

    struct NovelDetailResponse: ServiceModel {
        var response: ServiceNovelModel
    }
}

extension NovelDetailService {
    func fetchNovelDetailPublisher(_ novel: NovelModel, modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        WebService.downloadDataPublisher(self)
            .tryMap { (response: NovelDetailResponse) in
                let itemData = response.response
                guard !itemData.identifier.isEmpty || !itemData.name.isEmpty || itemData.identifier == novel.identifier else {
                    debugPrint("NovelDetailService: No data received or failed to decode response.")
                    throw NetworkError.failedToDecodeResponse
                }
                return itemData
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { itemData in
                novel.update(service: itemData, context: modelContext)
                try? modelContext.save()
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
