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
                CharacterHeaderView(viewModel: CharacterHeaderViewModel(character: viewModel.header), favorited: viewModel.isFavorited, favoriteButtonWasClicked: favoriteButtonWasClicked(id:))
                VStack {
                    Text(getDescription())
                }
            }.navigationBarTitle(getNavigationHeaderTitle())
        }
    }
    
}

extension CharacterDetailView {
    
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


