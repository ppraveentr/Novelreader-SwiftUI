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
    private var allNovels: [NovelModel] = []
    private var page: Int = 1
    private var pageSize: Int = 38
    private var canLoadNextPage = true

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
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = err
                } else {
                    self.page += 1
                    self.canLoadNextPage = self.page < self.pageSize
                }
                self.cancellables.removeAll()
            }, receiveValue: {
                do {
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
