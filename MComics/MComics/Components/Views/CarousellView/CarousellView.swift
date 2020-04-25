//
//  CarousellView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 25/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarousellView: View {
    
    // MARK: - Binding
    @Binding var items: [CarousellProtocol]
   
    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 20) {
                ForEach(0..<items.count, id: \.self) { index in
                    VStack(spacing: 0) {
                        self.getPhoto(photoURL: self.items[index].photoURL)
                            .frame(height: 110)
                        Text(self.items[index].title)
                            .lineLimit(2)
                            .font(.system(size: 12, weight: .medium))
                            .multilineTextAlignment(.center)
                    }.frame(width: 130)
                }
            }.frame(height: 150)
        }
    }

}

// MARK: Private fuctions
extension CarousellView {
    
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



