//
//  HomeView.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 26/10/22.
//

import SwiftUI

struct HomeView: View {
    @State
    private var searchText: String = ""

    var body: some View {
        VStack {
            Text("Hello, HomeView!")
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Title, Author")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
