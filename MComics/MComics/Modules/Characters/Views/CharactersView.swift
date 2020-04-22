//
//  CharactersView.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//


import SwiftUI


struct CharactersView: View {
    
    //MARK: - Variables
    @ObservedObject var viewModel: CharactersViewModel
    @State var characterDetailSelected: Int?
    @State private var showCancelButton: Bool = false
    
    //MARK: - Constructor
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Private Methods
    private func getNumberOfSections() -> Int {
        return self.viewModel.dataSource.count / 2
    }
    
    private func getHeaders(index: Int) -> some View  {
        let firstIndex: Int = index * 2
        let secondIndex: Int = index * 2 + 1
        return
            VStack {
                HStack {
                    self.getHeader(self.viewModel.dataSource[firstIndex])
                    if secondIndex < self.viewModel.dataSource.count {
                        self.getHeader(self.viewModel.dataSource[secondIndex])
                    } else {
                        EmptyView()
                    }
                }
                if index + 1 == self.getNumberOfSections() {
                    ActivityIndicator(isAnimating: self.viewModel.loading && !self.viewModel.filtering, style: .medium)
                        .onAppear {
                            self.viewModel.fetch()
                    }
                }
        }
    }
    
    private func getHeader(_ headerViewModel: CharacterViewModel) -> some View {
        return ZStack {
            NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(characterService: CharacterService(), characterId: headerViewModel.id)), tag: headerViewModel.id, selection: $characterDetailSelected) {
                EmptyView()
            }.buttonStyle(PlainButtonStyle())
            CharacterHeaderView(viewModel: headerViewModel).onTapGesture {
                self.characterDetailSelected = headerViewModel.id
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack
                {
                    SearchTextField(searchText: $viewModel.text, showCancelButton: $showCancelButton)
                    List {
                        ForEach(0..<getNumberOfSections(), id: \.self) { index in
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

