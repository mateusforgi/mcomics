//
//  FavoriteCharactersView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct FavoriteCharactersView: View {
    
    // MARK: - Observed
    @ObservedObject private var viewModel: FavoriteCharactersViewModel
    
    // MARK: - Constructor 
    init(viewModel: FavoriteCharactersViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List(viewModel.favoritedCharacters) { character in
                CharacterHeaderView(viewModel: character, favorited: self.isFavorited(for: character.id), favoriteButtonWasClicked: self.favoriteButtonWasClicked)
            }.onAppear {
                self.viewModel.getMyFavorites()
            }.navigationBarTitle(LocalizableStrings.favoritesHeader)
        }
    }
    
    private func favoriteButtonWasClicked(id: Int, name: String, photoURL: String) {
        viewModel.favorite(id: id, name: name, photoURL: photoURL)
    }
    
    private func isFavorited(for characterId: Int) -> Bool {
        return viewModel.favoritedCharacters.first(where: {$0.id == characterId}) != nil
    }
}
