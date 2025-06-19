//
//  Destinations.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 30/10/22.
//  Copyright (c) 2022 Praveen P. All rights reserved.
//

import SwiftUI

enum Destinations: String, CaseIterable, Identifiable {
    case home = "Novel", libary = "Libary", profile = "Profile"

    var id: String { self.rawValue }

    // For horizontalSizeClass == .compact
    static func tabBarView(_ selection: Binding<Destinations>) -> some View {
        TabView(selection: selection) {
            ForEach(Destinations.allCases, id: \.self) { $0.navigationView }
        }
    }

    // For all others
    static func sideBarView(_ selection: Binding<Destinations>) -> some View {
        let _selection: Binding<Destinations?> = Binding(selection)
        return NavigationView {
            List {
                ForEach(Destinations.allCases, id: \.self) { $0.navigationLink(_selection) }
            }
        }
    }
}

private extension Destinations {
    var tabBarLabel: some View {
        switch self {
        case .home:
            Label(id, systemImage: "house.fill")
        case .profile:
            Label(id, systemImage: "person")
        case .libary:
            Label(id, systemImage: "books.vertical.fill")
        }
    }

    @ViewBuilder
    var contentView: some View {
        switch self {
        case .home:
            NovelListView()
        case .profile:
            ProfileView()
        case .libary:
            LibaryView()
        }
    }

    @ViewBuilder
    var navigationView: some View {
        NavigationView {
            contentView
        }.tabItem { tabBarLabel }
        .tag(self)
    }

    @ViewBuilder
    func navigationLink(_ selection: Binding<Destinations?>) -> some View {
        NavigationLink(destination: contentView) {
            tabBarLabel
        }
    }
}
