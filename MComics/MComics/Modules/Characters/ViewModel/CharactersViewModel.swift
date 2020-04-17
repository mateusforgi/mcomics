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
    @Published var loading = false

    // MARK: - Variables
    private let characterService: CharacterServiceProtocol
    private var disposables = Set<AnyCancellable>()
    private var page = 0
    private var count = 0
    
    typealias CharactersResponse = (headers: [CharacterHeader], count: Int)
    // MARK: - Constructor
    init(characterService: CharacterServiceProtocol) {
        self.characterService = characterService
    }
    
    //MARK: - Public Methods
    public func fetch() {
        if loading {
            return
        }
        let offset = page * count
        self.loading = true
        characterService.getCharacters(offset)
            .receive(on: DispatchQueue.main)
            .map { response in
                (response.data.results.map(CharacterHeader.init), response.data.count)
        }.sink(
            receiveCompletion: { value in
                self.loading = false
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] (item: CharactersResponse) in
                guard let self = self else { return }
                self.loading = false
                self.dataSource.append(contentsOf: item.headers)
                self.page += 1
                self.count = item.count
        }).store(in: &disposables)
    }
    
}
