//
//  User.swift
//  TinkoffChat
//
//  Created by user on 29.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import CoreData

extension User {
    
    static func fetchRequestUser(model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "User"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest
    }
    
    static func findOrInsertUser(id: String, in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            assert(false)
            return nil
        }
        
        var user: User?
        guard let fetchRequest = User.fetchRequestUser(model: model) else { return nil }
        do {
            let results = try context.fetch(fetchRequest)
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
        
        if user == nil {
            user = User.insertUser(id: id, in: context)
        }
        return user

    }
    
    static func insertUser(id: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userId = id
            return user
        }
        return nil
    }
}









