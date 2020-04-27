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
    @Published var image: Data?
    
    // MARK: - Constructor
    init(character: CharacterHeaderProtocol) {
        id = character.id
        name = character.name
        photoURL = character.photoURL
        image = character.photo
    }
    
    // MARK: - Private Methods
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitMedium)
    }
}

