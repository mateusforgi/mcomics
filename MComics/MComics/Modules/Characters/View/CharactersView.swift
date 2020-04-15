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
        TabView {
            List {
                ForEach(viewModel.dataSource.indices, id: \.self) { index in
                    Text(self.viewModel.dataSource[index].name)
                }
            }.onAppear {
                self.viewModel.fetch()
            }.listStyle(PlainListStyle())
                .tabItem {
                    Image(systemName: "list.dash")
            }.tag(0)
            Text("Second View")
                .tabItem {
                    Image(systemName: "heart.circle.fill")
            }.tag(1)
            Text("Third View")
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
            }.tag(2)
        }
    }
    
}
