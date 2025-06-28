//
//  BookDetailViewModel.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/26/25.
//

import Foundation
import ContentManager
import Combine
import SwiftData
import SwiftUI

class BookDetailViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isChapterDetailsLoading: Bool = false
    @Published var error: Error?
    @Published var chapterError: Error?
    private var hasPageLoaded = false
    private var cancellables = Set<AnyCancellable>()

    enum FetchError: Error {
        case novelDetails(Error)
        case chapterList(Error)
    }

    @MainActor
    func isFavorite(_ novel: NovelModel) -> Bool {
        guard let server = AppManager.serverModelContainer else { return false }
        let serverNovel = NovelModelCopyService.getNovel(identifier: novel.identifier, context: server)
        return serverNovel != nil
    }

    // Fetches novel details, then chapters, in sequence
    @MainActor
    func fetchNovelAndChapters(_ novel: NovelModel, modelContext: ModelContext) {
        guard !hasPageLoaded && !isLoading else { return }
        (isLoading, isChapterDetailsLoading) = (true, true)
        (error, chapterError) = (nil, nil)
        NovelServices.syncNovelDetailsPublisher(novel, modelContext: modelContext)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .mapError { FetchError.novelDetails($0) }
            .flatMap { _ in
                NovelServices.syncChapterListPublisher(novel, modelContext: modelContext)
                    .subscribe(on: DispatchQueue.global(qos: .background))
                    .mapError { FetchError.chapterList($0) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    self.hasPageLoaded = true
                case .failure(let err):
                    switch err {
                    case .novelDetails(let underlying):
                        self.error = underlying
                    case .chapterList(let underlying):
                        self.chapterError = underlying
                    }
                }
                novel.isFavorite = isFavorite(novel)
                self.isLoading = false
                self.isChapterDetailsLoading = false
            } receiveValue: { _ in
                // Do nothing
            }
            .store(in: &cancellables)
    }

    /// Cancels all ongoing Combine subscriptions/services.
    func cancelServices() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    @MainActor
    func favoriteBook(_ novel: NovelModel) {
        Task {
            guard let local = AppManager.localModelContainer, let server = AppManager.serverModelContainer else { return }
            do {
                if !novel.isFavorite {
                    novel.isFavorite = true
                    _ = try await NovelModelCopyService.copyNovelWithChapters(identifier: novel.identifier,
                                                                               localContext: local,
                                                                               serverContext: server)
                } else {
                    novel.isFavorite = false
                    try await NovelModelCopyService.removeNovelWithChapters(identifier: novel.identifier, serverContext: server)
                }
            } catch {
                debugPrint("Error on favoriting book: \(error)")
            }
        }
    }
}
