//
//  CharacterDetailView.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/16/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterDetailView: View {
    
    // MARK: - Observed
    @ObservedObject private var viewModel: CharacterDetailViewModel
    
    // MARK: - Constructor
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            getErrorView()
            List {
                VStack {
                    getPhoto()
                        .frame(height: 300)
                    HStack {
                        Text(viewModel.header.name)
                            .lineLimit(2)
                            .font(Font.system(size: 17, weight: .semibold, design: .default))
                        FavoriteButtonView(id: viewModel.header.id, favorited: viewModel.isFavorited, favoriteButtonWasClicked: self.favoriteButtonWasClicked)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .trailing)
                    }
                }
                VStack {
                    Text(getDescription())
                }
            }.navigationBarTitle(getNavigationHeaderTitle())
        }
    }
    
}

// MARK: - Private Functions
extension CharacterDetailView {
    
    private func getPhoto() -> some View {
        CharacterPosterView(photoURL: viewModel.header.photoURL, image: viewModel.header.image)
    }
    
    private func favoriteButtonWasClicked(id: Int) {
        viewModel.favorite()
    }
    
    private func getDescription() -> String {
        return viewModel.description.isEmpty ? LocalizableStrings.characterHasNoDescriptionLabel : viewModel.description
    }
    
    private func getNavigationHeaderTitle() -> String {
        return String(viewModel.header.name.split(separator: " ").first ?? "")
    }
    
    private func getErrorView() -> some View {
        ErrorBannerView(error: $viewModel.error) {
            self.viewModel.error = nil
        }
    }
    
}


