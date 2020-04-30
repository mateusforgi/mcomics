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
    @State private var errorOnLoadingPhoto = false
    
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
                    Button(action: {
                        self.favoriteButtonWasClicked(self.viewModel.id)
                    }) {
                        self.getFavoriteIcon(for: viewModel.id)
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .trailing)
                }
            }
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
}

// MARK: Private Functions
extension CharacterHeaderView {
    
    private func getPhoto() -> some View {
        if errorOnLoadingPhoto {
            return AnyView(getPhotoLocally())
        }
        return AnyView(WebImage(url: URL(string: viewModel.photoURL))
            .onFailure { _ in
                self.errorOnLoadingPhoto.toggle()
        }
        .resizable()
        .placeholder {
            Rectangle().foregroundColor(.clear)
        }
        .indicator(.activity)
        .transition(.fade))
    }
    
    private func getPhotoLocally() -> some View {
        if let image = viewModel.image, let uiImage = UIImage(data: image) {
            return AnyView(Image(uiImage: uiImage)
                .resizable())
        }
        return AnyView(Rectangle())
    }
    
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

