//
//  CharacterSerieViewModel.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 23/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine

class CharacterSerieViewModel: ObservableObject, Identifiable, CarousellProtocol {
    
    // MARK: - Published
    @Published var title: String
    @Published var photoURL: String = ""
        
    // MARK: - Constructor
    init(serie: CharacterSerie) {
        title = serie.title
        photoURL = getPhotoURL(path: serie.imagePath, imageExtension: serie.imageExtension)
    }
    
    // MARK: - Private Methods
    private func getPhotoURL(path: String, imageExtension: String) -> String {
        return  MarvelAPIEnvironment.getPhotoURL(path: path, imageExtension: imageExtension, size: .portraitMedium)
    }
    
}
