//
//  StorageService.swift
//  TinkoffChat
//
//  Created by user on 17.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

protocol UserProfileStorage: class {
    func saveUser(user: UserProfile, completed: @escaping () -> (), failure: @escaping ()->())
    func getUser(completed: @escaping (_ name: String, _ aboutMe: String?, _ image: Data, _ textColor: NSString) -> ())
}

class StorageService: NSObject, UserProfileStorage {

    func saveUser(user: UserProfile, completed: @escaping () -> (), failure: @escaping ()->()) {
        GCDDataManager.saveFile(name: user.userName,
                                aboutMe: user.descriptionUser,
                                image: UIImagePNGRepresentation(user.userImage!)!,
                                colorText: user.textColor as String,
                                completed: {
                                    completed()
        }) {
            failure()
        }
    }
    
    func getUser(completed: @escaping (_ name: String, _ aboutMe: String?, _ image: Data, _ textColor: NSString) -> ()) {
        GCDDataManager.getFile { (name, aboutMe, imageData, textColor) in
            completed(name, aboutMe, imageData, textColor)
        }
    }
}

