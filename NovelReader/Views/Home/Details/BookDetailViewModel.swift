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

    // Fetches novel details, then chapters, in sequence
    @MainActor
    func fetchNovelAndChapters(_ novel: NovelModel, modelContext: ModelContext) {
        guard !hasPageLoaded && !isLoading else { return }
        isLoading = true
        isChapterDetailsLoading = true
        error = nil
        chapterError = nil
        NovelServices.syncNovelDetailsPublisher(novel, modelContext: modelContext)
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
                self.isLoading = false
                self.isChapterDetailsLoading = false
            } receiveValue: { _ in
                // Do nothing
            }
            .store(in: &cancellables)
    }
}
