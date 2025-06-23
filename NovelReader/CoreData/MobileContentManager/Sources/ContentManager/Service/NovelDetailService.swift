//
//  NovelDetailService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/22/25.
//

import Foundation
import SwiftData
import Networking

class NovelDetailService: RequestObject {
    typealias ResponseType = NovelDetailResponse.Type

    var type: ReqeustType { .GET }
    var baseURL = "http://localhost:3000/"
    var path = "novel/novel-details"

    var requestBody: Codable?
    var responseBody: Codable?
    var requestQuery: [URLQueryItem]?

    struct NovelDetailResponse: ServiceModel {
        var response: ServiceNovelModel
    }
}

extension NovelDetailService {
    @MainActor
    func refreshNovelDetail(_ novel: NovelModel, modelContext: ModelContext) async {
        do {
            let webService = WebService()
            let response: NovelDetailResponse = try await webService.downloadData(self)
            let itemData = response.response
            guard !itemData.identifier.isEmpty || !itemData.name.isEmpty || itemData.identifier == novel.identifier else {
                debugPrint("No data received or failed to decode (NovelDetailService) response.")
                return
            }
            DispatchQueue.main.async {
                novel.update(service: itemData, context: modelContext)
                try? modelContext.save()
            }
        } catch {
            debugPrint("Error fetching data (NovelDetailService)")
            debugPrint(error.localizedDescription)
        }
    }
}
