//
//  CharacterRepositoryProtocol.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

protocol CharacterRepositoryProtocol {
    
    func getMyFavorites(completion: @escaping ([FavoriteCharacterDTO]?, Error?) -> Void)
    func favoriteOrUnfavoriteCharacter(id: Int64, name: String, description: String, completion: @escaping (WasFavorited?, Error?) -> Void)
    func saveImage(image: Data, id: Int64, completion: @escaping (Error?) -> Void)
    func unFavorite(id: Int64, completion: @escaping (Error?) -> Void)
    
    typealias WasFavorited = Bool
    
}
