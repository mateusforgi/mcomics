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
    var photoExtension: String { item.thumbnail.imageExtension }
    var photoPath: String { item.thumbnail.path }
    var image: Data?

    init(item: CharacterInfoDTO, image: Data? = nil) {
        self.item = item
        self.image = image
    }
    
}

