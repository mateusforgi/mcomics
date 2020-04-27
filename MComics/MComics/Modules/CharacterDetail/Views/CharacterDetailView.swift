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
        List {
            getPosterHeader()
                .listRowInsets(EdgeInsets())
                .frame(height: 400)
            VStack {
                Text(viewModel.header?.name ?? "")
                    .font(.system(size: 24, weight: .medium))
                Text(viewModel.header?.description ?? "")
                    .font(.system(size: 14))
            }
        }.edgesIgnoringSafeArea(.top)
            .onAppear {
                self.viewModel.fetchHeader()
        }
    }

}

// MARK: - Private Functions
extension CharacterDetailView {

    private func getPosterHeader() -> some View {
        if let header = viewModel.header {
            return AnyView(CharacterPosterHeaderView(viewModel: header))
        } else {
            return AnyView(Rectangle().foregroundColor(.clear))
        }
    }
    
    private func getPhoto(photoURL: String) -> some View {
        return WebImage(url: URL(string: photoURL))
            .resizable()
            .placeholder {
                Rectangle().foregroundColor(.clear)
        }
        .indicator(.activity)
        .transition(.fade)
    }
    
}

