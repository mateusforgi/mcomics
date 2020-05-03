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
    @State private var animateArrow = false
    private var animationDuration: Double = 0.5
    @Environment(\.colorScheme) var colorScheme
    
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
                DispatchQueue.main.async {
                    self.errorOnLoadingPhoto = true
                }
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
        return AnyView(getRetryView())
    }
    
    private func getRetryView() -> some View {
        return VStack(alignment: .center) {
            Button(action: {
                DispatchQueue.main.async {
                    self.animateArrow = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                    self.animateArrow = false
                    self.errorOnLoadingPhoto = false
                }
            }) {
                Image(systemName: "arrow.clockwise")
                    .rotationEffect(.degrees(animateArrow ? 360 : 0))
                    .scaleEffect(animateArrow ? 0 : 1)
                    .animation(Animation.easeIn(duration: animationDuration))
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(colorScheme == .dark ? Color.white : Color.black)
                .scaleEffect(animateArrow ? 0 : 1)
                .animation(Animation.easeIn(duration: animationDuration))
        }
    }
    
}
