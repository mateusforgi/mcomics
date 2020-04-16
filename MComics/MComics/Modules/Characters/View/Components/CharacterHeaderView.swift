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
    
    // MARK: - Constants
    private let id: Int
    private let name: String
    private let description: String
    private let photoURL: String
    
    // MARK: - Constructor
    init(id: Int, name: String, description: String, photoURL: String) {
        self.id = id
        self.name = name
        self.description = description
        self.photoURL = photoURL
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center) {
            getPhoto()
                .frame(height: 200)
                .cornerRadius(10)
                .shadow(radius: 2)
            HStack {
                Image(systemName: "suit.heart")
                    .foregroundColor(Color.init(UIColor.systemTeal))
                Text(name)
                    .lineLimit(1)
                    .font(Font.system(size: 14, weight: .bold, design: .default))
            }
        }
    }
    
    private func getPhoto() -> some View {
        return WebImage(url: URL(string: photoURL))
            .resizable()
            .placeholder {
                Rectangle().foregroundColor(.clear)
        }
        .indicator(.activity)
        .transition(.fade)
    }
    
}

