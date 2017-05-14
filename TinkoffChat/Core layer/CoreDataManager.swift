//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by user on 29.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileServiceDelegate {
    
}

class CoreDataManager: NSObject, ProfileServiceDelegate {
    
    let coreDataStack: CoreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    
    func getAppUser(complitionHandler:(() -> Void)?) -> AppUser? {
        if let complete = complitionHandler {
            complete()
        }
        let appUser = AppUser.findOrInsertAppUser(in: coreDataStack.mainContext!)
        return appUser
    }
    
    func saveCurrentUser(user: User, complitionHandler:(() -> Void)?) {
        let appUser = AppUser.findOrInsertAppUser(in: coreDataStack.mainContext!)
        appUser?.currentUser = user
        coreDataStack.performSave(context: coreDataStack.mainContext!, completionHandler: complitionHandler)
    }
    
}
