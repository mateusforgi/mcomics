//
//  Character.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 26/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import CoreData

@objc (Character)
class Character: NSManagedObject {
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var image: Data?
}
