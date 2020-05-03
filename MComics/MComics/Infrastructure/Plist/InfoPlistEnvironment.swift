//
//  InfoPlistEnvironment.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct InfoPlistEnvironment {
    
    private static var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("Plist file not found")
        }
    }
    
    public static func getInfoPlistVariable(plistKey: PlistKey) -> String? {
        return infoDict[plistKey.rawValue] as? String
    }
    
}

