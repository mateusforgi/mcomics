//
//  HomeViewSpec.swift
//  MComicsUITests
//
//  Created by Mateus Forgiarini da Silva  on 01/05/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import XCTest
import KIF
import Nimble
import Quick
import Swifter
@testable import MComics

class CharactersTestSpec: QuickSpec {
    
    var server: HttpServer?
    
    func addCharacterStub() {
        startServer()
        server?.GET["/v1/public/characters"] = getResponse(filePath: "characters")
    }
    
    private func startServer() {
        server = HttpServer()
        do {
            try server?.start(8080)
        } catch {
            XCTFail("Unable to start server. Error details: \(error.localizedDescription)")
        }
    }
    
    private func stopServer() {
        server?.stop()
    }
    
    private func getResponse(filePath: String) -> ((HttpRequest) -> HttpResponse)? {
        var response: ((HttpRequest) -> HttpResponse)?
        
        if let path = Bundle(for: type(of: self)).path(forResource: filePath, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                response = { _ in
                    return HttpResponse.ok(.json(jsonResult as AnyObject))
                }
            } catch {
                XCTFail("Unable to parse \(filePath).json. Error details: \(error.localizedDescription)")
            }
        }
        return response
    }
    
    private func deleteCoreDataValues() {
        let context = AppDelegate.persistentContainer.viewContext
        CoreDataHelper.deleteCoreDataValues(entityName: String(describing: Character.self), context: context)
    }
    
    override func spec() {
        
        describe("navigating to home") {
            context("when I have no characters to see and the server gives me an error") {
                it("shows a retry button") {
                    let retryWasFound = self.searchForElement("Retry")
                    expect(retryWasFound).to(equal(true))
                }
                it("shows no search bar") {
                    let searchWasFound = self.searchForElement("Search")
                    expect(searchWasFound).to(equal(false))
                }
                it("shows the favorites tab") {
                    let favoritesWasFound = self.searchForElement("Favorites")
                    expect(favoritesWasFound).to(equal(true))
                }
                it("shows the characters tabs") {
                    let charactersWasFound = self.searchForElement("Characters")
                    expect(charactersWasFound).to(equal(true))
                }
            }
            
            context("when I tap retry") {
                beforeEach {
                    self.addCharacterStub()
                }
                it("shows the favorites tabs") {
                    self.tester().tapView(withAccessibilityLabel: "Retry")
                    let searchWasFound = self.searchForElement("Search")
                    expect(searchWasFound).to(equal(true))
                }
                
                it("shows characters tabs") {
                    let retryWasFound = self.searchForElement("Retry")
                    expect(retryWasFound).to(equal(false))
                }
                afterEach {
                    self.stopServer()
                }
            }
        }
        
        context("when I scroll the list up") {
            it("shows a banner error") {
                let homeView = self.tester().waitForView(withAccessibilityLabel: "Home")
                if let tableAccessibilityElement = homeView?.accessibilityElement(withLabel: "Characters List") {
                    self.tester().scroll(tableAccessibilityElement, in: homeView, byFractionOfSizeHorizontal: 0, vertical: 1000)
                }
                let bannerErrorView = self.tester().waitForView(withAccessibilityLabel: "Banner Error")
                expect(bannerErrorView != nil).to(equal(true))
            }
        }
        
        context("when I click on favorites tab") {
            beforeEach {
                self.deleteCoreDataValues()
            }
            it("shows an empty view") {
                self.tester().tapView(withAccessibilityLabel: "Favorites")
                let noChactersMessage = self.searchForElement("No favorite characters")
                expect(noChactersMessage).to(equal(true))
            }
        }
        
        context("when I go back to the characters list and I favorite one character") {
            it("it fills the favorite button heart") {
                self.tester().tapView(withAccessibilityLabel: "Characters")
                self.tester().tapView(withAccessibilityLabel: "Favorite 3-D Man")
                let unfavoriteButtonWasFound = self.searchForElement("Unfavorite 3-D Man")
                expect(unfavoriteButtonWasFound).to(equal(true))
            }
        }
        
        context("when I go back to the favorites list") {
            it("it now shows a favorite character") {
                self.tester().tapView(withAccessibilityLabel: "Favorites")
                let characterHeaderView = self.tester().waitForView(withAccessibilityLabel: "Unfavorite 3-D Man")
                expect(characterHeaderView != nil).to(equal(true))
            }
        }
        
        context("when I click the to unfavorite the character") {
            it("shows an empty view") {
                self.tester().tapView(withAccessibilityLabel: "Unfavorite 3-D Man")
                let noCharactersMessage = self.searchForElement("No favorite characters")
                expect(noCharactersMessage).to(equal(true))
            }
        }
        
        context("when I go back to the characters list and click to see the character detail") {
            it("it now shows the character detail") {
                self.tester().tapView(withAccessibilityLabel: "Characters")
                self.tester().tapView(withAccessibilityLabel: "3-D Man")
                let characterDetailWasFound = self.searchForElement("Character Detail")
                
                expect(characterDetailWasFound).to(equal(true))
            }
            
            it("it now shows the favorite button") {
                let favoriteButtonWasFound = self.searchForElement("Favorite 3-D Man")
                expect(favoriteButtonWasFound).to(equal(true))
            }
        }
    }
    
}

