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
    @Published var dataSource = [CharacterHeaderViewModel]()
    @Published var loading = false
    @Published var text: String = ""
    @Published var filtering: Bool = false
    
    // MARK: - Variables
    private let characterService: CharacterServiceProtocol
    private var disposables = Set<AnyCancellable>()
    private var page = 0
    private var count = 0
    private var items = [CharacterHeaderViewModel]()
    
    typealias CharactersResponse = (headers: [CharacterHeaderViewModel], count: Int)
    
    // MARK: - Constructor
    init(characterService: CharacterServiceProtocol) {
        self.characterService = characterService
        $text.dropFirst(1)
            .sink(receiveValue: self.search(_:))
            .store(in: &disposables)
    }
    
    private func search(_ text: String) {
        filtering = text != ""
        dataSource = filtering ? items.filter({$0.name.localizedCaseInsensitiveContains(text)}) : items
    }
    
    //MARK: - Public Methods
    public func fetch() {
        if loading || filtering {
            return
        }
        let offset = page * count
        self.loading = true
        characterService.getCharacters(offset)
            .receive(on: DispatchQueue.main)
            .map { response in
                let headers = response.data.results.map(CharacterHeader.init)
                return (headers.map(CharacterHeaderViewModel.init), response.data.count)
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
                self.items.append(contentsOf: item.headers)
                self.page += 1
                self.count = item.count
                self.dataSource = self.items
        }).store(in: &disposables)
    }
    
}
