//
//  ErrorView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 27/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    
    private var message: String
    private var tapAction: (() -> Void)?
    private var tapMessage: String?
    
    init(message: String, tapAction: (() -> Void)? = nil, tapMessage: String? = nil) {
        self.message = message
        self.tapAction = tapAction
        self.tapMessage = tapMessage
    }
    
    var body: some View {
        VStack {
            Text(message)
            tapAction.map { callback in
                Button(action: callback) {
                    Text(tapMessage ?? "")
                }
            }
        }
    }
    
}

