//
//  NovelServices.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/18/25.
//

import Combine
import Foundation
import SwiftData
import Networking

protocol BaseNovelRequest: RequestObject { }

extension BaseNovelRequest {
    var baseURL: String { NovelServices.appBaseURL }
}

public enum NovelServices {
    public static var appBaseURL = ""

    public static func syncNovelListPublisher(page: Int, modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        let listService = NovelListService()
        listService.requestQuery = [URLQueryItem(name: "page", value: String(page))]
        return listService.fetchNovelListPublisher(modelContext: modelContext)
    }

    public static func syncNovelDetailsPublisher(_ novel: NovelModel, modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        let detailService = NovelDetailService()
        let idQuery = URLQueryItem(name: "id", value: novel.identifier)
        detailService.requestQuery = [idQuery]
        return detailService.fetchNovelListPublisher(novel, modelContext: modelContext)
    }

    public static func syncChapterListPublisher(_ novel: NovelModel, modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        let chapterListService = NovelChapterListService()
        let idQuery = URLQueryItem(name: "id", value: novel.identifier)
        let pageQuery = URLQueryItem(name: "dataID", value: novel.novelDataId)
        chapterListService.requestQuery = [idQuery, pageQuery]
        return chapterListService.fetchChapterListPublisher(novel, modelContext: modelContext)
    }

    public static func syncGenericPublisher(modelContext: ModelContext) -> AnyPublisher<Void, Error> {
        let genreListService = GenreService()
        return genreListService.updateGenreListPublisher(modelContext)
    }

}
