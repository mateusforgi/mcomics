//
//  HomeViewSpec.swift
//  MComicsUITests
//
//  Created by Mateus Forgiarini da Silva  on 01/05/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import KIF
import Nimble
import Quick

class HomeViewTestSpec: QuickSpec {
    
    override func spec() {
        describe("navigating") { // 1
            context("to home screen") { // 2
                it("i should see the favorites and characters tabs") { // 3
                    let favoritesWasFound = self.searchForElement("Favorites")
                    let charactersWasFound = self.searchForElement("Characters")
                    expect(favoritesWasFound).to(equal(true))
                    expect(charactersWasFound).to(equal(true))
                }
            }
        }
    }
    
}
