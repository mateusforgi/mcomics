//
//  CharacterRepositoryTests.swift
//  MComicsTests
//
//  Created by Mateus Forgiarini da Silva  on 01/05/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import XCTest
@testable import MComics
import CoreData

class CharacterRepositoryTests: XCTestCase {
    
    struct CharacterHeaderTest: CharacterHeaderProtocol {
        
        var id: Int
        var name: String
        var photoURL: String
        var image: Data?
        var description: String
        
    }
    
    // MARK: - Variables
    private var container: NSPersistentContainer!
    private var characterRepository: CharacterRepository!
    private var context: NSManagedObjectContext!
    private let character = CharacterHeaderTest(id: 1, name: "name", photoURL: "photoURL", image: nil, description: "decription")
    
    // MARK: - Lyfecycle
    override func setUpWithError() throws {
        context = AppDelegate.persistentContainer.viewContext
        CoreDataHelper.deleteCoreDataValues(entityName: String(describing: Character.self), context: context)
        characterRepository = CharacterRepository(context: context)
    }
    
    override func tearDownWithError() throws {
        container = nil
    }
    
    // MARK: - Private Functions
    func verfifyAssertion(toInsert: CharacterHeaderProtocol, inserted: FavoriteCharacterDTO) {
        XCTAssertEqual(toInsert.id, inserted.id, "Expected id to be \(toInsert.id) but it was \(inserted.id)")
        XCTAssertEqual(toInsert.name, inserted.name, "Expected name to be \(toInsert.name) but it was \(inserted.name)")
        XCTAssertEqual(toInsert.photoURL, inserted.photoURL, "Expected photoURL to be \(toInsert.photoURL) but it was \(inserted.photoURL)")
        XCTAssertEqual(toInsert.image, inserted.image)
        XCTAssertEqual(toInsert.description, inserted.description, "Expected description to be \(toInsert.description) but it was \(inserted.description)")
    }
    
    private func insertMockAndWait(character: Character) {
        context.performAndWait {
            do {
                try self.context.save()
            } catch {
                XCTAssertNil(error, getErrorDescription(message: "Error on inserting mocking data", error: error))
                XCTFail()
            }
        }
    }
    
    private func getErrorDescription(message: String, error: Error?) -> String {
        return "\(message). Error description: \(error?.localizedDescription ?? "No error description")"
    }
    
    // MARK: - Favorite
    func testFavoriteOrUnfavoriteCharacterShouldFavorited() throws {
        let expectation = XCTestExpectation(description: "testFavoriteOrUnfavoriteCharacterShouldFavorited")
        characterRepository.favoriteOrUnfavoriteCharacter(character: character) { wasFavorited, error in
            XCTAssertNil(error, self.getErrorDescription(message: "Error on favoriting character", error: error))
            XCTAssertTrue(wasFavorited ?? false, "It should return wasfavorited true but it returned false")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testFavoriteOrUnfavoriteCharacterShouldUnFavorited() throws {
        let expectation = XCTestExpectation(description: "testFavoriteOrUnfavoriteCharacterShouldUnFavorited")
        let characterModel = Character(context: context)
        characterModel.id = Int64(character.id)
        insertMockAndWait(character: characterModel)
        characterRepository.favoriteOrUnfavoriteCharacter(character: character) { wasFavorited, error in
            XCTAssertNil(error, self.getErrorDescription(message: "Error on favoriting character", error: error))
            XCTAssertFalse(wasFavorited ?? true, "It should return wasfavorited false but it returned true")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    // MARK: - UnFavorite
    func testUnfavoriterCharacterShouldUnFavorited() throws {
        let expectation = XCTestExpectation(description: "testUnfavoriterCharacterShouldUnFavorited")
        let characterModel = Character(context: context)
        characterModel.id = Int64(character.id)
        insertMockAndWait(character: characterModel)
        self.characterRepository.unFavorite(id: 1) { error in
            XCTAssertNil(error, self.getErrorDescription(message: "Error on unfavoriting character", error: error))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testUnfavoriterCharacterShouldReturnError() throws {
        let expectation = XCTestExpectation(description: "testUnfavoriterCharacterShouldReturnError")
        self.characterRepository.unFavorite(id: 1) { error in
            XCTAssertNotNil(error, self.getErrorDescription(message: "Error on unfavoriting character", error: error))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    // MARK: - Get Favorites
    func testGetFavoritesCharacterShouldReturnItem() throws {
        let expectation = XCTestExpectation(description: "testGetFavoritesCharacterShouldReturnItem")
        characterRepository.favoriteOrUnfavoriteCharacter(character: character) { wasFavorited, errorOnFavorite in
            self.characterRepository.getMyFavorites { favorites, error in
                XCTAssertNil(error, self.getErrorDescription(message: "Error on get favorites", error: error))
                let favoritesNumber = favorites?.count ?? 0
                XCTAssertEqual(favoritesNumber, 1, "It should return 1 but it return \(favoritesNumber)")
                guard let favorited = favorites?.first else {
                    XCTFail(self.getErrorDescription(message: "", error: CharacterRepositoryError.notFound))
                    return
                }
                self.verfifyAssertion(toInsert: self.character, inserted: favorited)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testGetFavoritesCharacterShouldNotReturnItem() throws {
        let expectation = XCTestExpectation(description: "testGetFavoritesCharacterShouldNotReturnItem")
        self.characterRepository.getMyFavorites { favorites, error in
            XCTAssertNil(error, self.getErrorDescription(message: "Error on get favorites", error: error))
            XCTAssertEqual(favorites?.count, 0, "It should return 1 but it return 0")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    // MARK: - Constraints
    func testConstraintInsertTwoCharacterWithSameIdShouldReturnError() {
        let expectation = XCTestExpectation(description: "testConstraintInsertTwoCharacterWithSameIdShouldReturnError")
        let character1 = Character(context: context)
        let character2 = Character(context: context)
        
        character1.id = 1
        character2.id = 1
        context.perform {
            do {
                try self.context.save()
                XCTFail()
            } catch {
                XCTAssertNotNil(error, self.getErrorDescription(message: "Error testing contraints", error: error))
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testConstraintInsertTwoCharacterWithDifferentIdShouldReturnSuccess() {
        let expectation = XCTestExpectation(description: "testConstraintInsertTwoCharacterWithDifferentIdShouldReturnSuccess")
        let character1 = Character(context: context)
        let character2 = Character(context: context)
        
        character1.id = 1
        character2.id = 2
        context.perform {
            do {
                try self.context.save()
                expectation.fulfill()
            } catch {
                XCTAssertNil(error, self.getErrorDescription(message: "Error testing contraints", error: error))
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    // MARK: - Save photo
    func testSavePhotoShouldReturnError() {
        let expectation = XCTestExpectation(description: "testSavePhotoShouldReturnError")
        characterRepository.saveImage(image: Data(), id: Int64(character.id)) { error in
            XCTAssertNotNil(error, self.getErrorDescription(message: "Error saving image", error: error))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testSavePhotoShouldReturnSuccess() {
        let expectation = XCTestExpectation(description: "testSavePhotoShouldReturnSuccess")
        let characterModel = Character(context: context)
        characterModel.id = Int64(character.id)
        insertMockAndWait(character: characterModel)
        characterRepository.saveImage(image: Data(), id: Int64(character.id)) { error in
            XCTAssertNil(error, self.getErrorDescription(message: "Error saving image", error: error))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testSavePhotoVerfifyData() {
        let expectation = XCTestExpectation(description: "testSavePhotoVerfifyData")
        let characterModel = Character(context: context)
        characterModel.id = Int64(character.id)
        insertMockAndWait(character: characterModel)
        let data = Data(count: 1)
        characterRepository.saveImage(image: data, id: Int64(character.id)) { error in
            self.characterRepository.getMyFavorites { favorites, error in
                XCTAssertNil(error, self.getErrorDescription(message: "Error saving image", error: error))
                expectation.fulfill()
                guard let image = favorites?.first?.image else {
                    XCTFail(self.getErrorDescription(message: "Error saving image", error: CharacterRepositoryError.notFound))
                    return
                }
                XCTAssertEqual(image, data)
            }
        }
        wait(for: [expectation], timeout: 2)
    }
}
