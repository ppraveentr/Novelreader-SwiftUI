//
//  GenreService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/29/25.
//

import Foundation
import Combine
import SwiftData
import Networking

class GenreService: BaseNovelRequest {
    typealias ResponseType = GenreResponse.Type

    var type: ReqeustType { .GET }
    var path = "novel/genre-list"

    var requestBody: Codable?
    var responseBody: Codable?
    var requestQuery: [URLQueryItem]?

    struct GenreResponse: ServiceModel {
        var response: [ServiceGenresModel]
    }
}

extension GenreService {
    @MainActor
    func updateGenreListPublisher(_ modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        WebService.downloadDataPublisher(self)
            .tryMap { (response: GenreResponse) in
                let itemData = response.response.filter { !$0.identifier.isEmpty && !$0.name.isEmpty }
                guard !itemData.isEmpty else {
                    debugPrint("GenreService: No data received or failed to decode response.")
                    throw NetworkError.failedToDecodeResponse
                }
                return itemData
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { itemData in
                // Remove all existing GenresModel objects before inserting new ones
                Self.clearAllGenres(modelContext: modelContext)
                itemData.forEach {
                    let model = GenresModel(service: $0)
                    modelContext.insert(model)
                }
                try? modelContext.save()
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    @MainActor
    static func clearAllGenres(modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<GenresModel>()
        if let existingGenres = try? modelContext.fetch(fetchDescriptor) {
            for model in existingGenres {
                modelContext.delete(model)
            }
            try? modelContext.save()
        }
    }
}
