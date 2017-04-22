//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by user on 01.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

protocol StorageServiceProtocol: class {
    
    static func saveFile(name: String, aboutMe: String?, image: Data, colorText: String, completed: @escaping () -> (), failure: @escaping ()->())
    
    static func getFile(completed: @escaping (_ name: String, _ aboutMe: String?, _ image: Data, _ textColor: NSString) -> ())
}

class GCDDataManager: NSObject, StorageServiceProtocol {
    
    enum FileError: Error {
        case write
        case open
    }
    
    let manager = FileManager.default
    static let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static let plistPathInDocument = rootPath + "/User.plist"
    
    static func saveFile(name: String, aboutMe: String?, image: Data, colorText: String, completed: @escaping () -> (), failure: @escaping ()->()) {
        DispatchQueue.global(qos: .userInitiated).sync {
            let dic: NSMutableDictionary = ["name": name,
                                            "aboutMe": aboutMe!,
                                            "image": image,
                                            "colorText": colorText]
            
            if dic.write(toFile: plistPathInDocument, atomically: true) {
                DispatchQueue.main.async {
                    completed()
                }
            } else {
                DispatchQueue.main.async {
                    failure()
                }
            }
        }
    }
    
    static func getFile(completed: @escaping (_ name: String, _ aboutMe: String?, _ image: Data, _ textColor: NSString) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            if !FileManager.default.fileExists(atPath: plistPathInDocument) {
                let plistPathInBundle = Bundle.main.path(forResource: "User", ofType: "plist")
                do {
                    try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: plistPathInDocument)
                    getFile(completed: completed)
                } catch {
                    print(error)
                }
            } else {
                let userInfo = NSDictionary(contentsOfFile: plistPathInDocument)
                DispatchQueue.main.async {
                    completed(userInfo?["name"] as! String,
                              userInfo?["aboutMe"] as? String,
                              userInfo?["image"] as! Data,
                              userInfo?["colorText"] as! NSString)
                }
            }
        }
    }
}
