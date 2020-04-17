//
//  UIApplicationExtension.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/16/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
    
}
