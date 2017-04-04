//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by user on 04.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class OperationDataManager: Operation {
    
    let manager = FileManager.default
    static let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static let plistPathInDocument = rootPath + "/User.plist"
    
    var userName: String?
    var aboutMe: String?
    var image: Data?
    var colorText: String?
    
    init(userName: String?, aboutMe: String?, image: Data?, colorText: String?) {
        self.userName = userName
        self.aboutMe = aboutMe
        self.image = image
        self.colorText = colorText
    }
    
    
    override func main() {

    }
    
    override func start() {
        
        if self.isCancelled {
            return
        }
        
        let userDic: NSMutableDictionary = [:]
        
        if let name = self.userName {
            userDic["name"] = name
        }
        if let aboutMe = self.aboutMe {
            userDic["aboutMe"] = aboutMe
        }
        
        if let image = self.image {
            userDic["image"] = image
        }
        
        if let colorText = self.colorText {
            userDic["colorText"] = colorText
        }
        
        if !userDic.write(toFile: OperationDataManager.plistPathInDocument, atomically: true) {
            
        } else {

        }
    }
}
