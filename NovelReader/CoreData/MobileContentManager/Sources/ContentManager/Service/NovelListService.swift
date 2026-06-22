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

class NovelListService: BaseNovelRequest {
    typealias ResponseType = NovelListResponse.Type

    var type: ReqeustType { .GET }
    var path: String = "novel/list"
    var requestBody: Codable?
    var responseBody: Codable?
    var requestQuery: [URLQueryItem]?

    struct NovelListResponse: ServiceModel {
        var response: ServiceNovelListModel
    }
}

extension NovelListService {
    func fetchNovelListPublisher(_ list: NovelListModel, modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        WebService.downloadDataPublisher(self)
            .tryMap { (response: NovelListResponse) in
                let itemData = response.response.novels.filter { !$0.identifier.isEmpty && !$0.name.isEmpty }
                guard !itemData.isEmpty else {
                    debugPrint("NovelListService: No data received or failed to decode response.")
                    throw NetworkError.failedToDecodeResponse
                }
                return response.response
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { (novelList: ServiceNovelListModel) in
                list.update(from: novelList, context: modelContext)
                try? modelContext.save()
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
