//
//  FavoriteButtonView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 29/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct FavoriteButtonView: View {
    
    private var id: Int
    var favorited: Bool
    typealias FavoriteButtonWasClicked = (_ id: Int) -> Void
    var favoriteButtonWasClicked: FavoriteButtonWasClicked
    
    // MARK: - Constructor
    init(id: Int, favorited: Bool, favoriteButtonWasClicked: @escaping FavoriteButtonWasClicked) {
        self.id = id
        self.favorited = favorited
        self.favoriteButtonWasClicked = favoriteButtonWasClicked
    }
    
    var body: some View {
        Button(action: {
            self.favoriteButtonWasClicked(self.id)
        }) {
            self.getFavoriteIcon(for: id)
        }.buttonStyle(BorderlessButtonStyle())
    }
    
}

// MARK: - Private Functions
extension FavoriteButtonView {
    
    private func getFavoriteIcon(for characterId: Int) -> some View {
        if favorited {
            return Image(systemName: "suit.heart.fill")
                .foregroundColor(Color.init(UIColor.systemTeal))
        } else {
            return Image(systemName: "suit.heart")
                .foregroundColor(Color.init(UIColor.systemTeal))
        }
    }
    
}
