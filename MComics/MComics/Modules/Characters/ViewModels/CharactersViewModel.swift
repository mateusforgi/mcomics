//
//  CharactersViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine
import CoreData

class CharactersViewModel: ObservableObject, Identifiable {
    
    // MARK: - Published
    @Published var dataSource = [CharacterHeaderViewModel]()
    @Published var loading = false
    @Published var text: String = ""
    @Published var filtering: Bool = false
    @Published var favoritedCharacters = Set<Int>()
    
    // MARK: - Variables
    private let characterService: CharacterServiceProtocol
    private var disposables = Set<AnyCancellable>()
    private var page = 0
    private var count = 0
    private var items = [CharacterHeaderViewModel]()
    private let characterRepository: CharacterRepositoryProtocol
    
    typealias CharactersResponse = (headers: [CharacterHeaderViewModel], count: Int)
    
    // MARK: - Constructor
    init(characterService: CharacterServiceProtocol, characterRepository: CharacterRepositoryProtocol) {
        self.characterService = characterService
        self.characterRepository = characterRepository
        $text.dropFirst(1)
            .sink(receiveValue: self.search(_:))
            .store(in: &disposables)
        getMyFavorites()
    }
    
    private func search(_ text: String) {
        filtering = text != ""
        dataSource = filtering ? items.filter({$0.name.localizedCaseInsensitiveContains(text)}) : items
    }
    
    private func getMyFavorites() {
        characterRepository.getMyFavorites() { favorites, error in
            guard let favorites = favorites else {
                #warning("handle error")
                return
            }
            DispatchQueue.main.async {
                self.favoritedCharacters = Set(favorites.map({$0.id}))
            }
        }
    }
    
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitMedium)
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
                let headers = response.data.results.map({CharacterHeader(item: $0, photoURL: self.getPhotoURL(path: $0.thumbnail.path, imageExtension: $0.thumbnail.imageExtension))})
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
    
    public func favorite(id: Int, name: String, photoURL: String) {
        characterRepository.favoriteOrUnfavoriteCharacter(id: Int64(id), name: name) { wasFavorited, error in
            guard let wasFavorited = wasFavorited else {
                #warning("handle error")
                return
            }
            DispatchQueue.main.async {
                if wasFavorited {
                    self.favoritedCharacters.update(with: id)
                    self.saveImage(photoURL: photoURL, id: id)
                } else {
                    self.favoritedCharacters.remove(id)
                }
            }
        }
    }
    
    private func saveImage(photoURL: String, id: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let url = URL(string: photoURL) {
                do {
                    let image = try Data(contentsOf: url)
                    self?.characterRepository.saveImage(image: image, id: Int64(id)) { error in
                        #warning("handle error")
                    }
                } catch {}
            }
        }
    }
}
