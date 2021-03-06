//
//  DataDTO.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct DataDTO<T>: Decodable where T: Decodable {
    
    var results: [T]
    var total: Int
    var count: Int
    var limit: Int
    
    enum CodingKeys: String, CodingKey {
        case results,
        total,
        count,
        limit
    }
    
}
