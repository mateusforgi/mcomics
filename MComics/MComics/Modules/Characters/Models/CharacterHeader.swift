//
//  CharacterHeader.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterHeader {
    
    private let item: CharacterInfoDTO
    var id: Int { item.id }
    var name: String { item.name }
    var description: String { item.description }
    var imagePath: String { item.thumbnail.path }
    var imageExtension: String { item.thumbnail.imageExtension }

    init(item: CharacterInfoDTO) {
      self.item = item
    }
    
}

