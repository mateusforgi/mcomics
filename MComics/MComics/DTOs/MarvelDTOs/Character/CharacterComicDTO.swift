//
//  CharacterComicDTO.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 23/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterComicDTO: Decodable {
    
    var data: DataDTO<CharacterComicInfoDTO>
    
}
