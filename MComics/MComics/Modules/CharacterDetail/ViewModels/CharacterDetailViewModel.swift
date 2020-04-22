//
//  CharacterDetailViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/16/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine

class CharacterDetailViewModel: ObservableObject, Identifiable {
    
    // MARK: - Published
    @Published var header: CharacterHeader?

    // MARK: - Variables
    private let characterService: CharacterServiceProtocol
    private var disposables = Set<AnyCancellable>()
    private let characterId: Int
        
    // MARK: - Constructor
    init(characterService: CharacterServiceProtocol, characterId: Int) {
        self.characterService = characterService
        self.characterId = characterId
    }
    
    //MARK: - Public Methods
    public func fetch() {
        characterService.getCharacterDetail(characterId)
            .receive(on: DispatchQueue.main)
            .map { response in
                response.data.results.map(CharacterHeader.init)
        }.sink(
            receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] items in
                guard let self = self else { return }
                self.header = items.first
        }).store(in: &disposables)
    }
    
}
