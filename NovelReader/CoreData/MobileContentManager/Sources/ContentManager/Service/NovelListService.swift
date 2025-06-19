//
//  WebService.swift
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

    var requestBody: JSON?
    var responseBody: JSON?
    var requestQuery: JSON?

    struct NovelListResponse: ServiceModel {
        var response: [NovelServiceModel]
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
                itemData.forEach { modelContext.insert(NovelModel(service: $0)) }
                try? modelContext.save()
            }
        } catch {
            debugPrint("Error fetching data")
            debugPrint(error.localizedDescription)
        }
    }
}
