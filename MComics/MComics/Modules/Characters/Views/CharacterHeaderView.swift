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
    
    @ObservedObject var viewModel: CharacterHeaderViewModel
   
    // MARK: - Constructor
    init(viewModel: CharacterHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            getPhoto()
                .frame(height: 200)
                .cornerRadius(10)
                .shadow(radius: 2)
            HStack(alignment: .center) {
                Image(systemName: "suit.heart")
                    .foregroundColor(Color.init(UIColor.systemTeal))
                Text(viewModel.name)
                    .lineLimit(2)
                    .font(Font.system(size: 17, weight: .semibold, design: .default))
            }.frame(height: 45)
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

