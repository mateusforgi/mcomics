//
//  CoreDataHelper.swift
//  MComicsTests
//
//  Created by Mateus Forgiarini da Silva  on 02/05/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataHelper {
    
    static func deleteCoreDataValues(entityName: String, context: NSManagedObjectContext) {
        context.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try context.execute(deleteRequest)
                context.reset()
            } catch {
                context.reset()
            }
        }
    }
    
}

