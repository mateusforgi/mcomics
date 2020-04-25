//
//  CharacterHeaderViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 22/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

class CharacterHeaderViewModel: ObservableObject, Identifiable {
    
    // MARK: - Published
    @Published var id: Int
    @Published var name: String
    @Published var photoURL: String = ""
    
    // MARK: - Constructor
    init(character: CharacterHeader) {
        id = character.id
        name = character.name
        photoURL = getPhotoURL(path: character.imagePath, imageExtension: character.imageExtension)
    }
    
    // MARK: - Private Methods
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitMedium)
    }
}
