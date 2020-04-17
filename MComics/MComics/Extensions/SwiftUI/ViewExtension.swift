//
//  ViewExtension.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/16/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

extension View {
    
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
    
}
