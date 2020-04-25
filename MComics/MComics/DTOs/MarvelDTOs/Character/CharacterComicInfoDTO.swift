//
//  CharacterComicInfoDTO.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 23/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterComicInfoDTO: Decodable {
    
    let id: Int
    let title: String
    let thumbnail: ThumbnailDTO

}
