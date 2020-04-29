//
//  CharacterHeaderProtocol.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

protocol CharacterHeaderProtocol {
    
    var id: Int { get }
    var name: String { get }
    var photoURL: String { get }
    var image: Data? { get }
    var description: String { get }

}
