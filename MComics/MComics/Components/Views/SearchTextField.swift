//
//  SearchTextField.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/17/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct SearchTextField: View {
    
    // MARK: - State
    @Binding var searchText: String
    @Binding var showCancelButton: Bool
    
    // MARK: - Constructor
    init(searchText: Binding<String>, showCancelButton: Binding<Bool>) {
        _searchText = searchText
        _showCancelButton = showCancelButton
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(.primary)
                
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0.0 : 1.0)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            if showCancelButton  {
                Button(LocalizableStrings.cancelSearchButton) {
                    UIApplication.shared.endEditing(true)
                    self.searchText = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(showCancelButton)
    }
    
}
