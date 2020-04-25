//
//  CharacterSerieDTO.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 25/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterSerieDTO: Decodable {
    
    var data: DataDTO<CharacterSerieInfoDTO>
    
}
