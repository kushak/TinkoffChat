//
//  ProfileService.swift
//  TinkoffChat
//
//  Created by user on 29.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
    
    func getAppUser(complitionHandler:(() -> Void)?) -> AppUser?
    func saveProfile(user: User, complitionHandler:(() -> Void)?)
    
}

class ProfileService: NSObject, ProfileViewControllerDelegate {
    
    let coreDataStack: CoreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    
    func getAppUser(complitionHandler:(() -> Void)?) -> AppUser? {
        if let complete = complitionHandler {
            complete()
        }
        let appUser = AppUser.findOrInsertAppUser(in: coreDataStack.mainContext!)
        return appUser
    }
    
    func saveProfile(user: User, complitionHandler:(() -> Void)?) {
        let appUser = AppUser.findOrInsertAppUser(in: coreDataStack.mainContext!)
        appUser?.currentUser = user
        coreDataStack.performSave(context: coreDataStack.mainContext!, completionHandler: complitionHandler)
    }
}
