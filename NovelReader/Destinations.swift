//
//  Destinations.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 30/10/22.
//  Copyright (c) 2022 Praveen P. All rights reserved.
//

import SwiftUI

enum Destinations: String, CaseIterable, Identifiable, Hashable {
    case home = "Novel", libary = "Libary", search = "Search"

    var id: String { self.rawValue }

    // For horizontalSizeClass == .compact
    static func tabBarView(_ selection: Binding<Destinations>) -> some View {
        TabView(selection: selection) {
            ForEach(Destinations.allCases, id: \.self) { $0.tabView }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }

    // For all others
    static func sideBarView(_ selection: Binding<Destinations>) -> some View {
        let _selection: Binding<Destinations?> = Binding(selection)
        return NavigationStack {
            List {
                ForEach(Destinations.allCases, id: \.self) { $0.navigationLink(_selection) }
            }
        }
    }
}

private extension Destinations {
    var tabView: Tab<Destinations, some View, some View> {
        Tab(value: self, role: tabRole) { navigationView } label: { tabBarLabel }
    }

    var tabRole: TabRole? {
        self == .search ? .search : nil
    }

    var tabBarLabel: some View {
        switch self {
        case .home:
            Label(id, systemImage: "house.fill")
        case .libary:
            Label(id, systemImage: "books.vertical.fill")
        case .search:
            Label(id, systemImage: "magnifyingglass")
        }
    }

    @ViewBuilder
    var contentView: some View {
        switch self {
        case .home:
            NovelListView()
        case .libary:
            LibaryView()
        case .search:
            Text("Search")
        }
    }

    @ViewBuilder
    var navigationView: some View {
        NavigationStack {
            contentView
        }
        .tabItem { tabBarLabel }
        .tag(self)
    }

    @ViewBuilder
    func navigationLink(_ selection: Binding<Destinations?>) -> some View {
        NavigationLink(destination: contentView) {
            tabBarLabel
        }
    }
}
