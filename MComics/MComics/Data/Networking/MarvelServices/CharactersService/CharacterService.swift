//
//  CharacterService.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine

class CharacterService {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
}

extension CharacterService: NetworkManager, CharacterServiceProtocol {
    
    func getCharacterDetail(_ id: Int) -> AnyPublisher<CharacterDTO, Error> {
        let url = MarvelAPIEnvironment().getUrlFrom(endPoint: .characterById,
                                                    parameters: [.characterId: "\(id)"],
                                                    queryStrings: nil)
        return get(urlString: url)
    }
    
    func getCharacters(_ offset: Int) -> AnyPublisher<CharacterDTO, Error> {
        let url = MarvelAPIEnvironment().getUrlFrom(endPoint: .characters,
                                                    parameters: nil,
                                                    queryStrings: [.offset : "\(offset)"])
        return get(urlString: url)
    }
    
}
