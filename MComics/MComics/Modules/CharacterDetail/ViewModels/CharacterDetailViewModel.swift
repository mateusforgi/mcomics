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
    @Published var description: String
    @Published var isFavorited: Bool
    @Published var error: Error?
    
    // MARK: - Variables
    private (set) var header: CharacterHeaderProtocol
    private var characterRepository: CharacterRepositoryProtocol
    
    // MARK: - Constructor
    init(header: CharacterHeaderProtocol, characterRepository: CharacterRepositoryProtocol, isFavorited: Bool) {
        self.description = header.description
        self.header = header
        self.isFavorited = isFavorited
        self.characterRepository = characterRepository
    }
    
    public func favorite() {
        characterRepository.favoriteOrUnfavoriteCharacter(character: header) { [weak self] wasFavorited, error in
            guard let self = self else {
                return
            }
            guard let wasFavorited = wasFavorited else {
                DispatchQueue.main.async {
                    self.error = error
                }
                return
            }
            DispatchQueue.main.async {
                self.isFavorited = wasFavorited
                if wasFavorited {
                    self.saveImage(photoURL: self.header.photoURL, id: self.header.id)
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
