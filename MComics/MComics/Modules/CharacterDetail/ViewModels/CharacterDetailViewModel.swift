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
    @Published var header: CharacterPosterHeaderViewModel?
    @Published var series = [CharacterSeriesViewModel]()
    
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
    public func fetchHeader() {
        characterService.getCharacterDetail(characterId)
            .receive(on: DispatchQueue.main)
            .map { response in
                let header = response.data.results.map(CharacterHeader.init)
                return header.map(CharacterPosterHeaderViewModel.init)
        }.sink(
            receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
        },
            receiveValue: { [weak self] (items: [CharacterPosterHeaderViewModel]) in
                guard let self = self else { return }
                self.header = items.first
        }).store(in: &disposables)
    }
    
    public func fetchSeries() {
        characterService.getCharacterComics(characterId)
            .receive(on: DispatchQueue.main)
            .map { response in
                let series = response.data.results.map(CharacterComic.init)
                return series.map(CharacterSeriesViewModel.init)
        }.sink(
            receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
        },
            receiveValue: { [weak self] (items: [CharacterSeriesViewModel]) in
                guard let self = self else { return }
                self.series = items
        }).store(in: &disposables)
    }
    
}
