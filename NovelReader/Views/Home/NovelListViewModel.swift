//
//  NovelListViewModel.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 6/26/25.
//

import Foundation
import ContentManager
import Combine
import SwiftData
import SwiftUI

class NovelListViewModel: ObservableObject {
    @Published private(set) var novels: [NovelModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var searchQuery: String = ""
    @Published var selectedNovel: NovelModel?
    @Published private var novelListServiceModel: NovelListModel?

    private var type: NovelListType = .completed
    private var allNovels: [NovelModel] = []

    private var canLoadNextPage: Bool {
        guard let model = novelListServiceModel else { return true }
        return model.currentPage < model.pageCount
    }

    private var cancellables = Set<AnyCancellable>()
    private var searchCancellables: AnyCancellable?
    private var fetchDescriptor: FetchDescriptor<NovelModel> {
        FetchDescriptor<NovelModel>(
            predicate: #Predicate { !$0.identifier.isEmpty }
        )
    }

    init() {
        searchCancellables = $searchQuery
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in self?.filterNovels() }
//            .store(in: &cancellables)
    }

    @MainActor
    func refreshNovels(modelContext: ModelContext) {
        cancelServices()
        do {
            try? modelContext.delete(model: NovelListModel.self)
            try modelContext.delete(model: NovelModel.self)
        } catch {
            debugPrint("Failed to delete NovelModel.")
        }
        isLoading = false
        fetchNovels(modelContext)
    }

    // The context should be injected (from the SwiftUI environment)
    @MainActor
    func fetchNovels(_ modelContext: ModelContext) {
        novelListServiceModel = NovelListModel.fetchModel(for: type, modelContext: modelContext)
        guard let novelListServiceModel, cancellables.isEmpty, !isLoading && canLoadNextPage else { return }
        isLoading = true
        error = nil
        NovelServices.syncNovelListPublisher(novelListServiceModel, modelContext: modelContext)
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err
                }
                self.cancellables.removeAll()
            }, receiveValue: {
                do {
                    // Fetch latest NovelListModel (assuming one per type or using identifier if available)
                    self.allNovels = try modelContext.fetch(self.fetchDescriptor)
                    self.filterNovels()
                } catch {
                    self.error = error
                }
            })
            .store(in: &cancellables)
    }

    private func filterNovels() {
        if searchQuery.isEmpty {
            novels = allNovels
        } else {
            let lowercasedQuery = searchQuery.lowercased()
            novels = allNovels.filter { $0.name.lowercased().contains(lowercasedQuery) == true }
        }
    }

    /// Cancels all ongoing Combine subscriptions/services.
    func cancelServices() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
