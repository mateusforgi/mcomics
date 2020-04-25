//
//  CharacterPosterHeaderViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 23/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine

class CharacterPosterHeaderViewModel: ObservableObject, Identifiable {
    
    // MARK: - Published
    @Published var name: String
    @Published var photoURL: String = ""
    @Published var description: String = ""
    
    // MARK: - Constructor
    init(character: CharacterHeader) {
        description = character.description
        name = character.name
        photoURL = getPhotoURL(path: character.imagePath, imageExtension: character.imageExtension)
    }
    
    // MARK: - Private Methods
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitXLarge)
    }
    
}
