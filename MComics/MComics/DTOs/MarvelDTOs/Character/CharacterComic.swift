//
//  CharacterComic.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 23/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterComic {
    
    private let item: CharacterComicInfoDTO
    var id: Int { item.id }
    var title: String { item.title }
    var imagePath: String { item.thumbnail.path }
    var imageExtension: String { item.thumbnail.imageExtension }

    init(item: CharacterComicInfoDTO) {
      self.item = item
    }
    
}
