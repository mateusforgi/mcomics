//
//  CharacterHeaderView.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//


import SwiftUI
import SDWebImageSwiftUI

struct CharacterHeaderView: View {
    
    @ObservedObject private var viewModel: CharacterHeaderViewModel
    private var favorited: Bool
    typealias FavoriteButtonWasClicked = (_ id: Int) -> Void
    var favoriteButtonWasClicked: FavoriteButtonWasClicked
    
    // MARK: - Constructor
    init(viewModel: CharacterHeaderViewModel, favorited: Bool, favoriteButtonWasClicked: @escaping FavoriteButtonWasClicked) {
        self.viewModel = viewModel
        self.favorited = favorited
        self.favoriteButtonWasClicked = favoriteButtonWasClicked
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                getPhoto()
                    .frame(width: 100, height: 50)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                HStack {
                    Text(viewModel.name)
                        .lineLimit(2)
                        .font(Font.system(size: 17, weight: .semibold, design: .default))
                    FavoriteButtonView(id: viewModel.id, favorited: self.favorited, favoriteButtonWasClicked: self.favoriteButtonWasClicked)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .trailing)
                }
            }
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
}

// MARK: Private Functions
extension CharacterHeaderView {
    
    private func getPhoto() -> some View {
        CharacterPosterView(photoURL: viewModel.photoURL, image: viewModel.image)
    }

}

