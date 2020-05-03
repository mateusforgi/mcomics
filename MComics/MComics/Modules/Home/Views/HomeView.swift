//
//  HomeView.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//
import SwiftUI

struct HomeView: View {
    
    // MARK: - Constants
    private let characterViewFactory: CharacterViewFactoryProtocol
    @State private var showSplash = true
    @State private var splashAnimationStarted = false
    
    // MARK: - Constructor
    init(characterViewFactory: CharacterViewFactoryProtocol) {
        self.characterViewFactory = characterViewFactory
    }
    
    // MARK: - Body
    var body: some View {
        TabView {
            characterViewFactory.makeCharactersView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text(LocalizableStrings.charactersHeader)
            }.accessibility(identifier: "list").tag(0)
            characterViewFactory.makeFavoriteCharactersView()
                .tabItem {
                    Image(systemName: "heart.circle.fill")
                    Text(LocalizableStrings.favoritesHeader)
            }.tag(1)
        }
        .accentColor(Color.init(UIColor.systemTeal))
        .accessibility(label: Text(LocalizableStrings.accessibilityHomeView))
    }
    
}
