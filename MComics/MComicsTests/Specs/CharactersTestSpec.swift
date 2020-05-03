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
                it("shows an error message and a retry button") {
                    let retryWasFound = self.searchForElement("Retry")
                    let searchWasFound = self.searchForElement("Search")
                    expect(retryWasFound).to(equal(true))
                    expect(searchWasFound).to(equal(false))
                }
                it("shows the favorites and characters tabs") {
                    let favoritesWasFound = self.searchForElement("Favorites")
                    let charactersWasFound = self.searchForElement("Characters")
                    expect(favoritesWasFound).to(equal(true))
                    expect(charactersWasFound).to(equal(true))
                }
            }
            
            context("when I tap retry") {
                beforeEach {
                    self.addCharacterStub()
                }
                it("shows the favorites and characters tabs") {
                    self.tester().tapView(withAccessibilityLabel: "Retry")
                    let searchWasFound = self.searchForElement("Search")
                    expect(searchWasFound).to(equal(true))
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
            it("it nows shows a favorite character") {
                self.tester().tapView(withAccessibilityLabel: "Favorites")
                let characterHeaderView = self.tester().waitForView(withAccessibilityLabel: "Unfavorite 3-D Man")
                expect(characterHeaderView != nil).to(equal(true))
            }
        }
    }
    
}

