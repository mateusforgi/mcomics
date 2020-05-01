//
//  CharacterViewFactory.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 01/05/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

final class CharacterViewFactory: CharacterViewFactoryProtocol {
    
    internal let characterRepository: CharacterRepositoryProtocol
    internal let characterService: CharacterServiceProtocol
    
    init(characterRepository: CharacterRepositoryProtocol, characterService: CharacterServiceProtocol) {
        self.characterRepository = characterRepository
        self.characterService = characterService
    }
    
    func makeCharacterDetailView(header: CharacterHeaderProtocol, isFavorited: Bool) -> AnyView {
        return  AnyView(CharacterDetailView(viewModel: CharacterDetailViewModel(header: header, characterRepository: self.characterRepository, isFavorited: isFavorited)))
    }
    
    func makeCharactersView() -> AnyView {
        return AnyView(CharactersView(viewModel: CharactersViewModel(characterService: self.characterService, characterRepository: self.characterRepository, viewFactory: self)))
    }
    
    func makeFavoriteCharactersView() -> AnyView {
        return AnyView(FavoriteCharactersView(viewModel: FavoriteCharactersViewModel(characterRepository: self.characterRepository, viewFactory: self)))
    }

}
