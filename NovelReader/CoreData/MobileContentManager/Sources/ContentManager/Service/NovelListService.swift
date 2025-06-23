//
//  NovelListService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import Foundation
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
    func refreshNovels(modelContext: ModelContext) async {
        do {
            let webService = WebService()
            let response: NovelListResponse = try await webService.downloadData(self)
            let itemData = response.response.filter { !$0.identifier.isEmpty && !$0.name.isEmpty }
            guard !itemData.isEmpty else {
                debugPrint("No data received or failed to decode response.")
                return
            }
            DispatchQueue.main.async {
                itemData.forEach {
                    let model = NovelModel(service: $0)
                    model.update(service: $0, context: modelContext)
                    modelContext.insert(model)
                }
                try? modelContext.save()
            }
        } catch {
            debugPrint("Error fetching data")
            debugPrint(error.localizedDescription)
        }
    }
}
