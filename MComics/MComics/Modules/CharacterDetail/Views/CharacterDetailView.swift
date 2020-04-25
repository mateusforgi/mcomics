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
    @ObservedObject var viewModel: CharacterDetailViewModel
    
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
            getSeries()
            getComics()
        }.edgesIgnoringSafeArea(.top)
            .onAppear {
                self.viewModel.fetchHeader()
                self.viewModel.fetchSeries()
                self.viewModel.fetchComics()
        }
    }

}

// MARK: - Private Functions
extension CharacterDetailView {
    
    private func getSeries() -> some View {
        return
            VStack(alignment: .leading) {
                Text(LocalizableStrings.seriesHeader)
                    .font(Font.system(size: 34, weight: .bold))
                CarousellView(items: $viewModel.series)
        }
    }
    
    
    private func getComics() -> some View {
        return
            VStack(alignment: .leading) {
                Text(LocalizableStrings.comicsHeader)
                    .font(Font.system(size: 34, weight: .bold))
                CarousellView(items: $viewModel.comics)
        }
    }
    
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

