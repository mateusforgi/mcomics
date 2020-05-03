//
//  FavoriteCharacter.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct FavoriteCharacter: CharacterHeaderProtocol {
      
    private let character: FavoriteCharacterDTO
    var id: Int { character.id }
    var name: String { character.name }
    var photoPath: String { character.photoPath }
    var photoExtension: String { character.photoExtension }
    var image: Data?
    var description: String { character.description }
    
    init(character: FavoriteCharacterDTO) {
        self.character = character
        self.image = character.image
    }
    
}
