//
//  CharacterDetailView.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/16/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct CharacterDetailView: View {
    
    // MARK: - Variables
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    // MARK: - Constructor
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        Text(self.viewModel.header?.name ?? "").onAppear {
            self.viewModel.fetch()
        }
    }
}
