//
//  KifExtensions.swift
//  MComicsUITests
//
//  Created by Mateus Forgiarini da Silva  on 01/05/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import KIF
import Quick

extension QuickSpec {

    func tester(_ file : String = #file, _ line : Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }

    func system(_ file : String = #file, _ line : Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }

    func searchForElement(_ label: String) -> Bool{
        do {
            try tester().tryFindingView(withAccessibilityLabel: label)
            return true
        } catch {
            return false
            
        }
    }
}
