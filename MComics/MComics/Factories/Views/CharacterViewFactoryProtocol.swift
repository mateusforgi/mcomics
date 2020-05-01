//
//  CharacterViewFactoryProtocol.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 01/05/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

protocol CharacterViewFactoryProtocol: class {
    
    // MARK: - Variables
    var characterRepository: CharacterRepositoryProtocol { get }
    var characterService: CharacterServiceProtocol { get }

    // MARK: - Functions
    func makeCharacterDetailView(header: CharacterHeaderProtocol, isFavorited: Bool) -> AnyView
    func makeCharactersView() -> AnyView
    func makeFavoriteCharactersView() -> AnyView
    
}
