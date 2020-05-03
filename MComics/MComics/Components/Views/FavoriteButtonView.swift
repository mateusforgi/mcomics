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
    let accessibilityName: String
    
    // MARK: - Constructor
    init(id: Int, favorited: Bool, favoriteButtonWasClicked: @escaping FavoriteButtonWasClicked, accessibilityName: String) {
        self.id = id
        self.favorited = favorited
        self.favoriteButtonWasClicked = favoriteButtonWasClicked
        self.accessibilityName = accessibilityName
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.favoriteButtonWasClicked(self.id)
            }
        }) {
            Image(systemName: getFavoriteIcon())
            
        }.buttonStyle(BorderlessButtonStyle())
            .scaleEffect(favorited ? 1.2 : 1)
            .animation(.spring())
            .accessibility(label: Text(getAccessibilityLabel()))
    }
    
}

// MARK: - Private Functions
extension FavoriteButtonView {
    
    private func getFavoriteIcon() -> String {
        return favorited ? "suit.heart.fill" : "suit.heart"
    }
    
    private func getAccessibilityLabel() -> String {
        let format = favorited ? LocalizableStrings.accessibilityUnfavoriteButton : LocalizableStrings.accessibilityFavoriteButton
        return String(format: format, accessibilityName)
    }
    
}
