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
            VStack<AnyView>
                {
                    guard let headers = viewModel.dataSource else {
                        guard let error = viewModel.error else {
                            return AnyView(ActivityIndicator(isAnimating: viewModel.loading, style: .medium))
                        }
                        return AnyView(ErrorView(message: error.localizedDescription, tapAction: self.viewModel.fetch, tapMessage: LocalizableStrings.retryLabel))
                    }
                    if headers.isEmpty {
                        return AnyView(ErrorView(message: LocalizableStrings.noCharacters))
                    }
                    
                    return AnyView(VStack {
                        SearchTextField(searchText: $viewModel.text, showCancelButton: $showCancelButton)
                        getErrorView()
                        List {
                            ForEach(headers.indices, id: \.self) { index in
                                self.getHeaders(index: index, headers: headers)
                            }}.onAppear {
                                UITableView.appearance().tableFooterView = UIView()
                                UITableView.appearance().separatorStyle = .none
                                UITableViewCell.appearance().selectionStyle = .none
                        }.resignKeyboardOnDragGesture()
                    }.navigationBarTitle(LocalizableStrings.charactersHeader))
                    
            }.onAppear {
                self.viewModel.fetch()
                self.viewModel.getMyFavorites()
            }
        }
    }
    
}

// MARK: - Private Functions
extension CharactersView {
    
    private func getErrorView() -> some View {
        ErrorBannerView(error: $viewModel.error) {
            self.viewModel.error = nil
        }
    }
    
    private func getHeaders(index: Int, headers: [CharacterHeaderViewModel]) -> some View  {
        return
            VStack {
                HStack {
                    self.getHeader(headers[index])
                }
                if index + 1 == headers.count {
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
                    NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(header: headerViewModel.character, characterRepository: viewModel.characterRepository, isFavorited: isFavorited(for: headerViewModel.character.id)))) {
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
