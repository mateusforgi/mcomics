//
//  CharacterViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 22/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

class CharacterViewModel: ObservableObject, Identifiable {
    
    @Published var id: Int
    @Published var name: String
    @Published var description: String
    @Published var photoURL: String
    
    init(character: CharacterHeader) {
        id = character.id
        name = character.name
        description = character.description
        photoURL = ""
        photoURL = getPhotoURL(path: character.imageExtension, imageExtension: character.imageExtension)
    }
    
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitMedium)
    }
}
