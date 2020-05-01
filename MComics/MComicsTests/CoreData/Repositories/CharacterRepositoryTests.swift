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
        // Set in memory store
        container = NSPersistentContainer(name: "MComicsModel")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { (_, error) in
            XCTAssertNil(error)
        }
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        
        characterRepository = CharacterRepository(context: context)
    }
    
    override func tearDownWithError() throws {
        container = nil
    }
    
    // MARK: - Private Functions
    func verfifyAssertion(toInsert: CharacterHeaderProtocol, inserted: FavoriteCharacterDTO) {
        XCTAssertEqual(toInsert.id, inserted.id)
        XCTAssertEqual(toInsert.name, inserted.name)
        XCTAssertEqual(toInsert.photoURL, inserted.photoURL)
        XCTAssertEqual(toInsert.image, inserted.image)
        XCTAssertEqual(toInsert.description, inserted.description)
    }
    
    private func insertMockAndWait(character: Character) {
        context.performAndWait {
            do {
                try self.context.save()
            } catch {
                XCTAssertNil(error)
                XCTFail()
            }
        }
    }
    
    // MARK: - Favorite
    func testFavoriteOrUnfavoriteCharacterShouldFavorited() throws {
        let expectation = XCTestExpectation(description: "testFavoriteOrUnfavoriteCharacterShouldFavorited")
        characterRepository.favoriteOrUnfavoriteCharacter(character: character) { wasFavorited, error in
            XCTAssertNil(error)
            XCTAssertTrue(wasFavorited ?? false)
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
            XCTAssertNil(error)
            XCTAssertFalse(wasFavorited ?? true)
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
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testUnfavoriterCharacterShouldReturnError() throws {
        let expectation = XCTestExpectation(description: "testUnfavoriterCharacterShouldReturnError")
        self.characterRepository.unFavorite(id: 1) { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    // MARK: - Get Favorites
    func testGetFavoritesCharacterShouldReturnItem() throws {
        let expectation = XCTestExpectation(description: "testGetFavoritesCharacterShouldReturnItem")
        characterRepository.favoriteOrUnfavoriteCharacter(character: character) { wasFavorited, errorOnFavorite in
            self.characterRepository.getMyFavorites { favorites, error in
                XCTAssertNil(error)
                XCTAssertEqual(favorites?.count, 1)
                guard let favorited = favorites?.first else {
                    XCTFail()
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
            XCTAssertNil(error)
            XCTAssertEqual(favorites?.count, 0)
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
                XCTAssertNotNil(error)
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
                XCTAssertNil(error)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    // MARK: - Save photo
    func testSavePhotoShouldReturnError() {
        let expectation = XCTestExpectation(description: "testSavePhotoShouldReturnError")
        characterRepository.saveImage(image: Data(), id: Int64(character.id)) { error in
            XCTAssertNotNil(error)
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
            XCTAssertNil(error)
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
                XCTAssertNil(error)
                expectation.fulfill()
                guard let image = favorites?.first?.image else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(image, data)
            }
        }
        wait(for: [expectation], timeout: 2)
    }
}
