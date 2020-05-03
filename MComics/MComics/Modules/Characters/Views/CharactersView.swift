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
    
    //MARK: - Environment
    @Environment(\.colorScheme) var colorScheme
    
    //MARK: - State
    @State private var showCancelButton: Bool = false
    
    //MARK: - Constructor
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
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
                        return AnyView(ErrorView(error: error, tapAction: {self.viewModel.fetch(false)} , tapMessage: LocalizableStrings.retryLabel))
                    }
                    if headers.isEmpty && !showCancelButton {
                        return AnyView(ErrorView(error: CharacterError.noCharacters))
                    }
                    
                    return AnyView(getList(headers))
                    
                    
            }.onAppear {
                self.viewModel.fetch(true)
                self.viewModel.getMyFavorites()
            }
        }
    }
    
}

// MARK: - Private Functions
extension CharactersView {
    
    func getList(_ headers: [CharacterHeaderViewModel]) -> some View {
        return VStack {
            SearchTextField(searchText: $viewModel.text, showCancelButton: $showCancelButton)
                .padding([.leading, .trailing])
                .background(colorScheme == .dark ? Color.black : Color.white)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            getErrorView()
            List {
                ForEach(headers.indices, id: \.self) { index in
                    self.getHeaders(index: index, headers: headers)
                }
            }.accessibility(label: Text(LocalizableStrings.accessibilityCharactersList))
                .navigationBarTitle(LocalizableStrings.charactersHeader)
                .navigationBarHidden(showCancelButton)
        }
    }
    
    private func getErrorView() -> some View {
        BannerErrorView(error: $viewModel.error) {
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
                            self.viewModel.fetch(false)
                    }
                }
        }
    }
    
    private func getHeader(_ headerViewModel: CharacterHeaderViewModel) -> some View {
        return
            VStack {
                ZStack {
                    NavigationLink(destination: viewModel.viewFactory?.makeCharacterDetailView(header: viewModel.getHeaderForDetail(headerViewModel.character), isFavorited: isFavorited(for: headerViewModel.character.id))) {
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
        return viewModel.favoritedCharacters.first(where: {$0.key == characterId}) != nil
    }
    
}


