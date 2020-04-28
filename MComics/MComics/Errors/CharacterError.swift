//
//  CharacterError.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 27/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

enum CharacterError: Error {
    case notFound
}

extension CharacterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return LocalizableStrings.characterNotFound
        }
    }
}
