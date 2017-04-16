//
//  UserProfile.swift
//  TinkoffChat
//
//  Created by user on 06.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class UserProfile: NSObject {

    var userName: String = ""
    var descriptionUser: String = ""
    var userImage: UIImage?
    
    init (name: String, descript: String, image: UIImage) {
        super.init()
        
        userName = name
        descriptionUser = descript
        userImage = image
    }
}
