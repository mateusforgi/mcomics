//
//  CharacterSerieInfoDTO.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 25/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterSerieInfoDTO: Decodable {
    
    let id: Int
    let title: String
    let thumbnail: ThumbnailDTO

}
