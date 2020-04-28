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
    @Published var dataSource: [CharacterHeaderViewModel]?
    @Published var loading = false
    @Published var text: String = ""
    @Published var filtering: Bool = false
    @Published var favoritedCharacters = Set<Int>()
    @Published var error: Error?

    // MARK: - Variables
    private let characterService: CharacterServiceProtocol
    private var disposables = Set<AnyCancellable>()
    private var page = 0
    private var limit = 0
    private var total = 0
    private var noMoreData: Bool = false

    private var items = [CharacterHeaderViewModel]()
    private let characterRepository: CharacterRepositoryProtocol
    
    
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
        characterRepository.getMyFavorites() { [weak self] favorites, error in
            DispatchQueue.main.async {
                guard let favorites = favorites else {
                    self?.error = error
                    return
                }
                self?.favoritedCharacters = Set(favorites.map({$0.id}))
            }
        }
    }
    
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitMedium)
    }
    
    //MARK: - Public Methods
    public func fetch() {
        self.error = nil
        if loading || filtering || noMoreData {
            return
        }
        var offset = page * limit
        if offset >= total {
            offset = total == 0 ? 0 : total - 1
        }
        self.loading = true
        characterService.getCharacters(offset)
            .receive(on: DispatchQueue.main)
            .map { [weak self] response in
                self?.total = response.data.total
                self?.limit = response.data.limit
                if response.data.count < response.data.limit {
                    self?.noMoreData = true
                }
                let headers = response.data.results.map({CharacterHeader(item: $0, photoURL: self?.getPhotoURL(path: $0.thumbnail.path, imageExtension: $0.thumbnail.imageExtension) ?? "")})
                return (headers.map(CharacterHeaderViewModel.init))
        }.sink(
            receiveCompletion: { value in
                self.loading = false
                switch value {
                case .failure(let error):
                    self.error = error
                    break
                case .finished:
                    break
                }
        },
            receiveValue: { [weak self] (items: [CharacterHeaderViewModel]) in
                guard let self = self else { return }
                self.loading = false
                self.items.append(contentsOf: items)
                self.page += 1
                self.dataSource = self.items
        }).store(in: &disposables)
    }
    
    public func favorite(id: Int) {
        guard let character = self.dataSource?.first(where: {$0.character.id == id})?.character as? CharacterHeader else {
            DispatchQueue.main.async {
                self.error = CharacterError.notFound
            }
            return
        }
        characterRepository.favoriteOrUnfavoriteCharacter(id: Int64(id), name: character.name, description: character.description) { [weak self] wasFavorited, error in
            guard let wasFavorited = wasFavorited else {
                DispatchQueue.main.async {
                    self?.error = error
                }
                return
            }
            DispatchQueue.main.async {
                if wasFavorited {
                    self?.favoritedCharacters.update(with: id)
                    self?.saveImage(photoURL: character.photoURL, id: id)
                } else {
                    self?.favoritedCharacters.remove(id)
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
                        DispatchQueue.main.async {
                            self?.error = error
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.error = error
                    }
                }
            }
        }
    }
}
