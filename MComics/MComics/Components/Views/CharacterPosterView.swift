//
//  CharacterPosterView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 29/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterPosterView: View {
    
    // MARK: - Variables
    private var photoURL: String
    private var image: Data?
    @State private var errorOnLoadingPhoto = false

    // MARK: - Constructor
    init(photoURL: String, image: Data?) {
        self.photoURL = photoURL
        self.image = image
    }
    
    var body: some View {
        getPhoto()
    }
    
}

// MARK: - Private Functions
extension CharacterPosterView {
    
    private func getPhoto() -> some View {
        if errorOnLoadingPhoto {
            return AnyView(getPhotoLocally())
        }
        return AnyView(WebImage(url: URL(string: photoURL))
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
        if let image = image, let uiImage = UIImage(data: image) {
            return AnyView(Image(uiImage: uiImage)
                .resizable())
        }
        return AnyView(Rectangle())
    }

    
}
