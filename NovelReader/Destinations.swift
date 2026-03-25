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
//        .tabViewStyle(.sidebarAdaptable)
    }

    // For all others
    static func sideBarView(_ selection: Binding<Destinations>) -> some View {
        NavigationSplitView(sidebar: {
            // Using this workaround because Selection binding on List in sidebar behaves inconsistently on iOS.
            // So we manually handle tap gesture and highlight the selected item.
            List(Destinations.allCases, id: \.self) { destination in
                destination.tabBarLabel
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection.wrappedValue = destination
                    }
                    .background(
                        selection.wrappedValue == destination ? Color.accentColor.opacity(0.15) : Color.clear
                    )
            }
        }, detail: {
            selection.wrappedValue.contentView
        })
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
