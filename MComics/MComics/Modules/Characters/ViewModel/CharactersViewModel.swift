//
//  CharactersViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine

class CharactersViewModel: ObservableObject, Identifiable {
    
    // MARK: - Published
    @Published var dataSource = [CharacterHeader]()
    
    // MARK: - Variables
    private let characterService: CharacterServiceProtocol
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    init(characterService: CharacterServiceProtocol) {
        self.characterService = characterService
    }
    
    //MARK: - Public Methods
    public func fetch() {
        characterService.getCharacters()
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
                self.dataSource.append(contentsOf: items)
        }).store(in: &disposables)
    }
    
}
