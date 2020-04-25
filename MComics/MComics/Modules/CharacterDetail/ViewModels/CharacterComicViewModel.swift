//
//  CharacterComicViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 25/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

class CharacterComicViewModel: ObservableObject, Identifiable, CarousellProtocol {
    
    // MARK: - Published
    @Published var title: String
    @Published var photoURL: String = ""
    
    // MARK: - Constructor
    init(comic: CharacterComic) {
        title = comic.title
        photoURL = getPhotoURL(path: comic.imagePath, imageExtension: comic.imageExtension)
    }
    
    // MARK: - Private Methods
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitMedium)
    }
    
}
