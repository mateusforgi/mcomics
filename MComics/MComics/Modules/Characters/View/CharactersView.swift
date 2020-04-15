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
    
    //MARK: - Body
    var body: some View {
        List(viewModel.dataSource, id: \.id) { header in
            self.getHeader(header)
        }.onAppear {
            self.viewModel.fetch()
        }
    }
    
    private func getHeader(_ header: CharacterHeader) -> some View {
        return CharacterHeaderView(id: header.id, name: header.name, description: header.description, photoURL: header.getPhotoURL())
    }
    
}
