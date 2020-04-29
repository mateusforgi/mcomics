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
    private var photoHeight: CGFloat
    @State private var errorOnLoadingPhoto = false
    
    // MARK: - Constructor
    init(viewModel: CharacterHeaderViewModel, favorited: Bool, favoriteButtonWasClicked: @escaping FavoriteButtonWasClicked, photoHeight: CGFloat = 300) {
        self.viewModel = viewModel
        self.favorited = favorited
        self.favoriteButtonWasClicked = favoriteButtonWasClicked
        self.photoHeight = photoHeight
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            getPhoto()
                .frame(height: photoHeight)
                .cornerRadius(10)
                .shadow(radius: 2)
            HStack(alignment: .center) {
                Button(action: {
                    self.favoriteButtonWasClicked(self.viewModel.id)
                }) {
                    self.getFavoriteIcon(for: viewModel.id)
                }.buttonStyle(BorderlessButtonStyle())
                Text(viewModel.name)
                    .lineLimit(2)
                    .font(Font.system(size: 17, weight: .semibold, design: .default))
            }.frame(height: 45)
        }
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

