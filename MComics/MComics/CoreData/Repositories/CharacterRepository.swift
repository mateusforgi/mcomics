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
    
    private func createCharacter(id: Int64, name: String, description: String, photoURL: String, completion: @escaping (Error?) -> Void) {
        context.perform {
            let character = Character(context: self.context)
            character.id = id
            character.name = name
            character.characterDescription = description
            character.photoURL = photoURL
            
            do {
                try self.context.save()
                self.context.reset()
                completion(nil)
            } catch {
                self.context.reset()
                completion(error)
            }
        }
    }
    
    private func getCharacterNSManagedObjectID(id: Int64, completion: @escaping (NSManagedObjectID?, Error?) -> Void) {
        context.perform {
            let request = self.getRequest()
            do {
                request.predicate = self.getCharacterIdPredicate(id: id)
                let result = try self.context.fetch(request)
                completion(result.first?.objectID, nil)
                self.context.reset()
            } catch {
                self.context.reset()
                completion(nil, error)
            }
        }
    }
    
    private func deleteCharacter(objectId: NSManagedObjectID, completion: @escaping (Error?) -> Void) {
        context.perform {
            let object = self.context.object(with: objectId)
            self.context.delete(object)
            do {
                try self.context.save()
                self.context.reset()
                completion(nil)
            } catch {
                self.context.reset()
                completion(error)
            }
        }
    }
    
}

extension CharacterRepository: CharacterRepositoryProtocol {
    
    func getMyFavorites(completion: @escaping ([FavoriteCharacterDTO]?, Error?) -> Void) {
        context.perform {
            let request = self.getRequest()
            do {
                let result = try self.context.fetch(request)
                let myFavorites = result.map({FavoriteCharacterDTO(id: Int($0.id), name: $0.name, image: $0.image, photoURL: $0.photoURL, description: $0.characterDescription)})
                self.context.reset()
                completion(myFavorites, nil)
            } catch {
                self.context.reset()
                completion(nil, error)
            }
        }
    }
    
    func unFavorite(id: Int64, completion: @escaping (Error?) -> Void) {
        self.getCharacterNSManagedObjectID(id: id) { objectId, error in
            guard let objectId = objectId else {
                completion(error ?? CharacterRepositoryError.notFound)
                return
            }
            self.deleteCharacter(objectId: objectId, completion: completion)
        }
    }
    
    func favoriteOrUnfavoriteCharacter(character: CharacterHeaderProtocol, completion: @escaping (WasFavorited?, Error?) -> Void) {
        let id = Int64(character.id)
        context.perform {
            self.getCharacterNSManagedObjectID(id: id) { objectId, error in
                guard let error = error else {
                    var wasFavorited: Bool?
                    if let objectId = objectId {
                        wasFavorited = false
                        self.deleteCharacter(objectId: objectId, completion: { deleteError in
                            completion(wasFavorited, deleteError)
                        })
                    } else {
                        wasFavorited = true
                        self.createCharacter(id: id, name: character.name, description: character.description, photoURL: character.photoURL, completion: { createError in
                            completion(wasFavorited, createError)
                        })
                    }
                    return
                }
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
