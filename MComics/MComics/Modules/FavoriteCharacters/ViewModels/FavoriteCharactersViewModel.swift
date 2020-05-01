//
//  FavoriteCharactersViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class FavoriteCharactersViewModel: ObservableObject, Identifiable {
    
    // MARK: - Published
    @Published var favoritedCharacters: [CharacterHeaderViewModel]?
    @Published var error: Error?
    @Published var loading = false
    
    // MARK: - Private Variables
    private let characterRepository: CharacterRepositoryProtocol
    
    // MARK: - Public Variables
    weak var viewFactory: CharacterViewFactoryProtocol?
    
    // MARK: - Constructor
    init(characterRepository: CharacterRepositoryProtocol, viewFactory: CharacterViewFactoryProtocol) {
        self.characterRepository = characterRepository
        self.viewFactory = viewFactory
    }
    
    // MARK: - Public Functions
    public func getMyFavorites() {
        self.error = nil
        self.loading = true
        characterRepository.getMyFavorites() { [weak self] favorites, error in
            DispatchQueue.main.async {
                self?.loading = false
                guard let favorites = favorites else {
                    self?.error = error
                    return
                }
                self?.favoritedCharacters = favorites.map(FavoriteCharacter.init).map(CharacterHeaderViewModel.init)
            }
        }
    }
    
    public func favorite(id: Int) {
        characterRepository.unFavorite(id: Int64(id)) { [weak self] error in
            DispatchQueue.main.async {
                guard let error = error else {
                    self?.favoritedCharacters?.removeAll(where: {$0.id == id})
                    
                    return
                }
                self?.error = error
            }
        }
    }
    
}

