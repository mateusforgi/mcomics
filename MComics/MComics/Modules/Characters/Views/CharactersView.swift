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
    @ObservedObject var viewModel: CharactersViewModel
    
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
                    CharacterHeaderView(viewModel: headerViewModel).buttonStyle(BorderlessButtonStyle())
                }
                HStack(alignment: .center) {
                    Button(action: {
                        self.favoriteButtonWasClicked(id: headerViewModel.id, name: headerViewModel.name)
                    }) {
                        self.getFavoriteIcon(for: headerViewModel.id)
                    }.buttonStyle(BorderlessButtonStyle())
                    Text(headerViewModel.name)
                        .lineLimit(2)
                        .font(Font.system(size: 17, weight: .semibold, design: .default))
                }.frame(height: 45)
        }
    }
    
    private func favoriteButtonWasClicked(id: Int, name: String) {
        viewModel.favorite(id: id, name: name)
    }
    
    private func getFavoriteIcon(for characterId: Int) -> some View {
        if viewModel.favoritedCharacters.first(where: {$0 == characterId}) == nil {
            return Image(systemName: "suit.heart")
                .foregroundColor(Color.init(UIColor.systemTeal))
        } else {
            return Image(systemName: "suit.heart.fill")
                .foregroundColor(Color.init(UIColor.systemTeal))
        }
    }
    
}
