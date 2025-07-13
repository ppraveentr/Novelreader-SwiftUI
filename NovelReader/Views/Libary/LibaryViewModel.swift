//
//  LibaryViewModel.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/26/25.
//

import Foundation
import ContentManager
import Combine
import SwiftData
import SwiftUI

class LibaryViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private var page: Int = 1
    private var pageSize: Int = 38
    private var canLoadNextPage = true

    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func refreshNovels(modelContext: ModelContext) {
        cancelServices()
        do {
            try modelContext.delete(model: NovelModel.self)
        } catch {
            debugPrint("Failed to delete NovelModel.")
        }
        page = 1
        canLoadNextPage = true
        isLoading = false
        fetchNovels(modelContext: modelContext)
    }

    // The context should be injected (from the SwiftUI environment)
    @MainActor
    func fetchNovels(modelContext: ModelContext) {
        guard cancellables.isEmpty, !isLoading && canLoadNextPage else { return }
        isLoading = true
        error = nil
        NovelServices.syncNovelListPublisher(page: page, modelContext: modelContext)
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .delay(for: .milliseconds(Int.random(in: 0...200)), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err
                } else {
                    self.page += 1
                    self.canLoadNextPage = self.page < pageSize
                }
                self.cancellables.removeAll()
            }, receiveValue: {
               // Do nothing
            })
            .store(in: &cancellables)
    }

    /// Cancels all ongoing Combine subscriptions/services.
    func cancelServices() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
