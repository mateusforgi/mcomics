//
//  CharacterInfoDTO.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct CharacterInfoDTO: Decodable {
    
    let id: Int
    let name: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case
        id,
        name,
        description
    }
    
}
