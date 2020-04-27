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
    @Published var header: CharacterDetailHeaderViewModel?
    @Published var series = [CarousellProtocol]()
    @Published var comics = [CarousellProtocol]()
    
    // MARK: - Variables
    private let characterService: CharacterServiceProtocol
    private var disposables = Set<AnyCancellable>()
    private let characterId: Int
    
    // MARK: - Constructor
    init(characterService: CharacterServiceProtocol, characterId: Int) {
        self.characterService = characterService
        self.characterId = characterId
    }
    
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitMedium)
    }
    
    //MARK: - Public Methods
    public func fetchHeader() {
        characterService.getCharacterDetail(characterId)
            .receive(on: DispatchQueue.main)
            .map { response in
                let header = response.data.results.map({CharacterHeader(item: $0, photoURL: self.getPhotoURL(path: $0.thumbnail.path, imageExtension: $0.thumbnail.imageExtension))})
                return header.map(CharacterDetailHeaderViewModel.init)
        }.sink(
            receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
        },
            receiveValue: { [weak self] (items: [CharacterDetailHeaderViewModel]) in
                guard let self = self else { return }
                self.header = items.first
        }).store(in: &disposables)
    }
    
    public func fetchSeries() {
        characterService.getCharacterSeries(characterId)
            .receive(on: DispatchQueue.main)
            .map { response in
                let series = response.data.results.map(CharacterSerie.init)
                return series.map(CharacterSerieViewModel.init)
        }.sink(
            receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
        },
            receiveValue: { [weak self] (items: [CharacterSerieViewModel]) in
                guard let self = self else { return }
                self.series = items
        }).store(in: &disposables)
    }
    
    public func fetchComics() {
        characterService.getCharacterComics(characterId)
            .receive(on: DispatchQueue.main)
            .map { response in
                let series = response.data.results.map(CharacterComic.init)
                return series.map(CharacterComicViewModel.init)
        }.sink(
            receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
        },
            receiveValue: { [weak self] (items: [CharacterComicViewModel]) in
                guard let self = self else { return }
                self.comics = items
        }).store(in: &disposables)
    }
    
}
