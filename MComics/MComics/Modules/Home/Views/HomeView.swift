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
    private let favoriteCharactersViewModel: FavoriteCharactersViewModel
   
    // MARK: - Constructor
    init(charactersViewModel: CharactersViewModel, favoriteCharactersViewModel: FavoriteCharactersViewModel) {
        self.charactersViewModel = charactersViewModel
        self.favoriteCharactersViewModel = favoriteCharactersViewModel
    }
    
    // MARK: - Body
    var body: some View {
        TabView {
            CharactersView(viewModel: charactersViewModel)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text(LocalizableStrings.charactersHeader)
            }.tag(0)
            FavoriteCharactersView(viewModel: favoriteCharactersViewModel)
                .tabItem {
                    Image(systemName: "heart.circle.fill")
                    Text(LocalizableStrings.favoritesHeader)
            }.tag(1)
        }
        .accentColor(Color.init(UIColor.systemTeal))
    }
    
}
