//
//  HomeView.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//
import SwiftUI

struct HomeView: View {
    
    // MARK: - Constants
    private let charactersViewModel: CharactersViewModel
    
    // MARK: - Constructor
    init(charactersViewModel: CharactersViewModel) {
        self.charactersViewModel = charactersViewModel
    }
    
    // MARK: - Body
    var body: some View {
        TabView {
            CharactersView(viewModel: charactersViewModel)
                .tabItem {
                    Image(systemName: "list.dash")
            }.tag(0)
            Text("Second View")
                .tabItem {
                    Image(systemName: "heart.circle.fill")
            }.tag(1)
        }
        .accentColor(Color.init(UIColor.systemTeal))
    }
    
}
