//
//  CharacterRepository.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import CoreData

struct CharacterRepository {
   
    // MARK: - Context
    let context: NSManagedObjectContext
    
    // MARK: - Constructor
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: Private Functions
    private func getCharacterIdPredicate(id: Int64) -> NSPredicate {
        return NSPredicate(format: "%K == %i", #keyPath(Character.id), id)
    }
    
    private func getRequest() -> NSFetchRequest<Character> {
        let entityName = String(describing: Character.self)
        return NSFetchRequest<Character>(entityName: entityName)
    }
    
    private func createCharacter(id: Int64, name: String) {
        let character = Character(context: self.context)
        character.id = id
        character.name = name
    }
}

extension CharacterRepository: CharacterRepositoryProtocol {
    
    func getMyFavorites(completion: @escaping ([FavoriteCharacterDTO]?, Error?) -> Void) {
        context.perform {
            let request = self.getRequest()
            do {
                let result = try self.context.fetch(request)
                let myFavorites = result.map({FavoriteCharacterDTO(id: Int($0.id), name: $0.name, image: $0.image)})
                self.context.reset()
                completion(myFavorites, nil)
            } catch {
                self.context.reset()
                completion(nil, error)
            }
        }
    }
    
    func favoriteOrUnfavoriteCharacter(id: Int64, name: String, completion: @escaping (WasFavorited?, Error?) -> Void) {
        context.perform {
            let request = self.getRequest()
            do {
                request.predicate = self.getCharacterIdPredicate(id: id)
                let result = try self.context.fetch(request)
                var wasFavorited: Bool?
                if result.isEmpty {
                    self.createCharacter(id: id, name: name)
                    wasFavorited = true
                } else {
                    wasFavorited = false
                    for object in result {
                        self.context.delete(object)
                    }
                }
                do {
                    try self.context.save()
                    self.context.reset()
                    completion(wasFavorited, nil)
                } catch {
                    self.context.reset()
                    completion(nil, error)
                }
            } catch {
                self.context.reset()
                completion(nil, error)
            }
        }
    }
    
    func saveImage(image: Data, id: Int64, completion: @escaping (Error?) -> Void) {
        context.perform {
            let request = self.getRequest()
            do {
                request.predicate = self.getCharacterIdPredicate(id: id)
                let result = try self.context.fetch(request)
                result.first?.image = image
                do {
                    try self.context.save()
                    self.context.reset()
                    completion(nil)
                } catch {
                    self.context.reset()
                    completion(error)
                }
            } catch {
                self.context.reset()
                completion(error)
            }
        }
    }
    
}
