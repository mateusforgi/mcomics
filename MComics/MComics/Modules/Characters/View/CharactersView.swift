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
        return HStack {
            self.getHeader(self.viewModel.dataSource[firstIndex])
            if secondIndex < self.viewModel.dataSource.count {
                self.getHeader(self.viewModel.dataSource[secondIndex])
            } else {
                EmptyView()
            }
        }
    }
    
    private func getHeader(_ header: CharacterHeader) -> some View {
        return CharacterHeaderView(id: header.id, name: header.name, description: header.description, photoURL: header.getPhotoURL())
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            List(0..<getNumberOfSections(), id: \.self) { index in
                self.getHeaders(index: index)
            }.onAppear {
                self.viewModel.fetch()
                UITableView.appearance().tableFooterView = UIView()
                UITableView.appearance().separatorStyle = .none
                UITableViewCell.appearance().selectionStyle = .none
            }.navigationBarTitle(LocalizableStrings.charactersHeader)
        }
    }
    
}

