//
//  CharacterHeader.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterHeader: CharacterHeaderProtocol {
   
    private let item: CharacterInfoDTO
    var id: Int { item.id }
    var name: String { item.name }
    var description: String { item.description }
    var photoURL: String
    var image: Data?

    init(item: CharacterInfoDTO, photoURL: String, image: Data? = nil) {
        self.item = item
        self.photoURL = photoURL
        self.image = image
    }
    
}

