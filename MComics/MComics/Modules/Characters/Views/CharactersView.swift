//
//  CharactersView.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//


import SwiftUI


struct CharactersView: View {
    
    //MARK: - Observed
    @ObservedObject private var viewModel: CharactersViewModel
    
    //MARK: - State
    @State private var showCancelButton: Bool = false
    
    //MARK: - Constructor
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack
                {
                    SearchTextField(searchText: $viewModel.text, showCancelButton: $showCancelButton)
                    List {
                        ForEach(viewModel.dataSource.indices, id: \.self) { index in
                            self.getHeaders(index: index)
                        }}.onAppear {
                            self.viewModel.fetch()
                            UITableView.appearance().tableFooterView = UIView()
                            UITableView.appearance().separatorStyle = .none
                            UITableViewCell.appearance().selectionStyle = .none
                    }.resignKeyboardOnDragGesture()
                        .navigationBarTitle(LocalizableStrings.charactersHeader)
            }
        }
        
    }
}

// MARK: - Private Functions
extension CharactersView {
    
    private func getHeaders(index: Int) -> some View  {
        return
            VStack {
                HStack {
                    self.getHeader(self.viewModel.dataSource[index])
                }
                if index + 1 == self.viewModel.dataSource.count {
                    ActivityIndicator(isAnimating: self.viewModel.loading && !self.viewModel.filtering, style: .medium)
                        .onAppear {
                            self.viewModel.fetch()
                    }
                }
        }
    }
    
    private func getHeader(_ headerViewModel: CharacterHeaderViewModel) -> some View {
        return
            VStack {
                ZStack {
                    NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(characterService: CharacterService(), characterId: headerViewModel.id))) {
                        EmptyView()
                    }.buttonStyle(BorderlessButtonStyle())
                    CharacterHeaderView(viewModel: headerViewModel, favorited: isFavorited(for: headerViewModel.id), favoriteButtonWasClicked: favoriteButtonWasClicked(id:)).buttonStyle(BorderlessButtonStyle())
                }
        }
    }
    
    private func favoriteButtonWasClicked(id: Int) {
        viewModel.favorite(id: id)
    }
    
    private func isFavorited(for characterId: Int) -> Bool {
        return viewModel.favoritedCharacters.first(where: {$0 == characterId}) != nil
    }
    
}
