//
//  CharacterSrie.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 25/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterSerie {
    
    private let item: CharacterSerieInfoDTO
    var id: Int { item.id }
    var title: String { item.title }
    var imagePath: String { item.thumbnail.path }
    var imageExtension: String { item.thumbnail.imageExtension }

    init(item: CharacterSerieInfoDTO) {
      self.item = item
    }
    
}
