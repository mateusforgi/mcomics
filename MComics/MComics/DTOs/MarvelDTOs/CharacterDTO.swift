//
//  CharacterDTO.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterDTO: Decodable {
    
    var data: DataDTO<CharacterInfoDTO>
    
}

