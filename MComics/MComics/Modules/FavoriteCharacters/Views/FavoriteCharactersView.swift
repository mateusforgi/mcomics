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
            VStack<AnyView> {
                guard let favorites = viewModel.favoritedCharacters else {
                    guard let error = viewModel.error else {
                        return AnyView(ActivityIndicator(isAnimating: viewModel.loading, style: .medium))
                    }
                    return AnyView(ErrorView(error: error, tapAction: self.viewModel.getMyFavorites, tapMessage: LocalizableStrings.retryLabel))
                }
                if favorites.isEmpty {
                    return AnyView(ErrorView(error: CharacterError.noFavorites))
                }
                return AnyView(List(favorites) { character in
                    ZStack {
                        NavigationLink(destination: self.viewModel.viewFactory?.makeCharacterDetailView(header: character.character, isFavorited: self.isFavorited(for: character.id))) {
                            EmptyView()
                        }.buttonStyle(BorderlessButtonStyle())
                        CharacterHeaderView(viewModel: character, favorited: self.isFavorited(for: character.id), favoriteButtonWasClicked: self.favoriteButtonWasClicked)
                    }
                })
            }.navigationBarTitle(LocalizableStrings.favoritesHeader).onAppear {
                self.viewModel.getMyFavorites()
            }
        }
    }
    
}

extension FavoriteCharactersView {
    
    private func favoriteButtonWasClicked(id: Int) {
        viewModel.favorite(id: id)
    }
    
    private func isFavorited(for characterId: Int) -> Bool {
        return viewModel.favoritedCharacters?.first(where: {$0.id == characterId}) != nil
    }
    
}
