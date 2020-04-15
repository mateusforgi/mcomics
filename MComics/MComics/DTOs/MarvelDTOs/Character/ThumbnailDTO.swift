//
//  ThumbnailDTO.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/15/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct ThumbnailDTO: Decodable {
    
    var path: String
    var imageExtension: String
    enum CodingKeys: String, CodingKey {
        case path,
        imageExtension = "extension"
    }
    
}
