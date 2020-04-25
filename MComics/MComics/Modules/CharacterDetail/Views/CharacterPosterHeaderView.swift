//
//  CharacterPosterHeaderView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 23/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterPosterHeaderView: View {
    
    // MARK: - Observed
    @ObservedObject var viewModel: CharacterDetailHeaderViewModel
    
    // MARK: - Constructor
    init(viewModel: CharacterDetailHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        getPhoto()
    }
    
}

// MARK: - Private functions
extension CharacterPosterHeaderView {
    
    private func getPhoto() -> some View {
        return WebImage(url: URL(string: viewModel.photoURL))
            .resizable()
            .placeholder {
                Rectangle().foregroundColor(.clear)
        }
        .indicator(.activity)
        .transition(.fade)
    }
    
}
