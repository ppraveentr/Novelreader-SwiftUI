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
    private let type: NovelListType = .completed
    private var listModel: NovelListModel?

    private var canLoadNextPage: Bool {
        guard let model = listModel else { return true }
        return model.currentPage < model.pageCount
    }

    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func refreshNovels(modelContext: ModelContext) {
        cancelServices()
        do {
            try modelContext.delete(model: NovelModel.self)
        } catch {
            debugPrint("Failed to delete NovelModel.")
        }
        do {
            try modelContext.delete(model: NovelListModel.self)
        } catch {
            debugPrint("Failed to delete NovelListModel.")
        }
        listModel = nil
        isLoading = false
        fetchNovels(modelContext)
    }

    // The context should be injected (from the SwiftUI environment)
    @MainActor
    func fetchNovels(_ modelContext: ModelContext) {
        guard cancellables.isEmpty, !isLoading && canLoadNextPage else { return }
        isLoading = true
        error = nil

        // Ensure we have a persisted NovelListModel for this list type
        if listModel == nil {
            listModel = NovelListModel.fetchModel(for: type, modelContext: modelContext)
        }

        guard let listModel else {
            isLoading = false
            return
        }

        // If we've reached the last page, stop
        guard canLoadNextPage || listModel.currentPage == 0 else {
            isLoading = false
            return
        }

        NovelServices.syncNovelListPublisher(listModel, modelContext: modelContext)
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .delay(for: .milliseconds(Int.random(in: 0...200)), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err
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
