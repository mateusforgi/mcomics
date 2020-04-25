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
            getHeader()
                .listRowInsets(EdgeInsets())
                .frame(minHeight: 400)
            getSeries()
        }.edgesIgnoringSafeArea(.all)
            .onAppear {
                self.viewModel.fetchHeader()
                self.viewModel.fetchSeries()
        }
    }
    
    private func getSeries() -> some View {
        return
            VStack(alignment: .leading) {
                Text(LocalizableStrings.seriesHeader)
                    .font(Font.system(size: 34, weight: .bold))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 20) {
                        ForEach(self.viewModel.series) { serie in
                            VStack {
                                self.getPhoto(photoURL: serie.photoURL)
                                    .frame(width: 130, height: 130)
                                Text(serie.title)
                                    .font(.system(size: 12, weight: .medium))
                            }
                        }
                    }.frame(height: 150)
                }
            }
    }
    
    private func getHeader() -> some View {
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
