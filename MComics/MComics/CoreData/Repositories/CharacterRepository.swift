//
//  CharacterRepository.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import CoreData

struct CharacterRepository {
   
    // MARK: Private Functions
    private func getCharacterIdPredicate(id: Int64) -> NSPredicate {
        return NSPredicate(format: "%K == %i", #keyPath(Character.id), id)
    }
    
    private func getRequest() -> NSFetchRequest<Character> {
        let entityName = String(describing: Character.self)
        return NSFetchRequest<Character>(entityName: entityName)
    }
    
    // MARK: Public Functions
    func getMyFavorites(context: NSManagedObjectContext, completion: @escaping ([FavoriteCharacterDTO]?, Error?) -> Void) {
        context.perform {
            let request = self.getRequest()
            do {
                let result = try context.fetch(request)
                let myFavorites = result.map({FavoriteCharacterDTO(id: Int($0.id), name: $0.name)})
                context.reset()
                completion(myFavorites, nil)
            } catch {
                context.reset()
                completion(nil, error)
            }
        }
    }
    
    func favoriteOrUnfavoriteCharacter(id: Int64, name: String, context: NSManagedObjectContext, completion: @escaping (Bool?, Error?) -> Void) {
        context.perform {
            let request = self.getRequest()
            do {
                request.predicate = self.getCharacterIdPredicate(id: id)
                let result = try context.fetch(request)
                var wasFavorited: Bool?
                if result.isEmpty {
                    let character = Character(context: context)
                    character.id = id
                    character.name = name
                    wasFavorited = true
                } else {
                    wasFavorited = false
                    for object in result {
                        context.delete(object)
                    }
                }
                do {
                    try context.save()
                    context.reset()
                    completion(wasFavorited, nil)
                } catch {
                    context.reset()
                    completion(nil, error)
                }
            } catch {
                context.reset()
                completion(nil, error)
            }
        }
    }
    
    struct FavoriteCharacterDTO {
        
        let id: Int
        let name: String
        
    }
}
