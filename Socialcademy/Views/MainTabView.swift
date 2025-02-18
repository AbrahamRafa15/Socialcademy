//
//  MainTabView.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 17/07/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PostsList()
                .tabItem { 
                    Label("Posts", systemImage: "list.dash")
                }
            PostsList(viewModel: PostViewModel(filter: .favorites))
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            ProfileView().tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

#Preview {
    MainTabView()
}
