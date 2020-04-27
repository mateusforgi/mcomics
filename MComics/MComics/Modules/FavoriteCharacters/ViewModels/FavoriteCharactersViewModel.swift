//
//  FavoriteCharactersViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine

class FavoriteCharactersViewModel: ObservableObject, Identifiable {
    
    // MARK: - Published
    @Published var favoritedCharacters = [CharacterHeaderViewModel]()
    
    // MARK: - Variables
    let characterRepository: CharacterRepositoryProtocol
    
    // MARK: - Constructor
    init(characterRepository: CharacterRepositoryProtocol) {
        self.characterRepository = characterRepository
    }
    
    public func getMyFavorites() {
        characterRepository.getMyFavorites() { favorites, error in
            guard let favorites = favorites else {
                #warning("handle error")
                return
            }
            DispatchQueue.main.async {
                self.favoritedCharacters = favorites.map(FavoriteCharacter.init).map(CharacterHeaderViewModel.init)
            }
        }
    }
    
    public func favorite(id: Int, name: String, photoURL: String) {
        characterRepository.favoriteOrUnfavoriteCharacter(id: Int64(id), name: name) { _, error in
            guard let error = error else {
                self.favoritedCharacters.removeAll(where: {$0.id == id})
                return
            }
            #warning("handle error")
        }
    }
}
