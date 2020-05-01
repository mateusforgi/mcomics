//
//  ResignKeyboardOnDragGesture.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/16/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct ResignKeyboardOnDragGesture: ViewModifier {
   
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
    
}
