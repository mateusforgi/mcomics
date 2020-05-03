//
//  ErrorView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 27/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    
    // MARK: - Variables
    private var error: Error
    private var tapAction: (() -> Void)?
    private var tapMessage: String?
    
    // MARK: - Constructor
    init(error: Error, tapAction: (() -> Void)? = nil, tapMessage: String? = nil) {
        self.error = error
        self.tapAction = tapAction
        self.tapMessage = tapMessage
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            if isOffline() {
                Image(systemName: "wifi.slash")
            }
            Text(error.localizedDescription)
            tapAction.map { callback in
                Button(action: callback) {
                    Text(tapMessage ?? "")
                }
            }
        }
    }
    
    
}

// MARK: - Private Functions
extension ErrorView {
    
    private func isOffline() -> Bool {
        return error._code == -1009
    }
    
}
