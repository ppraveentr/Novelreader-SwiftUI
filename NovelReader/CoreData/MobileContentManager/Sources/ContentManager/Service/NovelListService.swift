//
//  NovelListService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import Foundation
import Combine
import SwiftData
import Networking

class NovelListService: RequestObject {
    typealias ResponseType = NovelListResponse.Type

    var type: ReqeustType { .GET }
    var baseURL = "http://localhost:3000/"
    var path = "novel/list"

    var requestBody: Codable?
    var responseBody: Codable?
    var requestQuery: [URLQueryItem]?

    struct NovelListResponse: ServiceModel {
        var response: [ServiceNovelModel]
    }
}

extension NovelListService {
    @MainActor
    func fetchNovelListPublisher(modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        let webService = WebService()
        return webService.downloadDataPublisher(self)
            .tryMap { (response: NovelListResponse) in
                let itemData = response.response.filter { !$0.identifier.isEmpty && !$0.name.isEmpty }
                guard !itemData.isEmpty else {
                    debugPrint("NovelListService: No data received or failed to decode response.")
                    throw NetworkError.failedToDecodeResponse
                }
                return itemData
            }
            .handleEvents(receiveOutput: { itemData in
                itemData.forEach {
                    let model = NovelModel(service: $0)
                    model.update(service: $0, context: modelContext)
                    modelContext.insert(model)
                }
                try? modelContext.save()
            })
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
