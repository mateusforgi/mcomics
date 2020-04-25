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
    @ObservedObject var viewModel: CharacterPosterHeaderViewModel
    
    // MARK: - Constructor
    init(viewModel: CharacterPosterHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            getPhoto()
                .frame(height: 400)
            VStack {
                Text(viewModel.name)
                    .font(.system(size: 24, weight: .medium))
                Text(viewModel.description)
                    .font(.system(size: 14))
            }.padding(10)
        }
    }
    
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
