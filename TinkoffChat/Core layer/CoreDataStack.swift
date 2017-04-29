//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by user on 28.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {
//    func getMasterContext() -> NSManagedObjectContext
//    func getMainContext() -> NSManagedObjectContext
//    func getSaveContext() -> NSManagedObjectContext?
//    func getCoreDataModel() -> NSManagedObjectModel
}

class CoreDataStack: NSObject {
    //MARK: - URL
    private var storeURL: URL {
        get {
            let documentsDirURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirURL.appendingPathComponent("Store.sqlite")
            return url
        }
    }
    
    //MARK: - NSManagedObjectModel
    private let managedObjectModelName = "TinkoffChat"
    private var _managedObjectModel: NSManagedObjectModel?
    public var managedObjectModel: NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil {
                guard  let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
                    print("Empty model url!")
                    return nil
                }
                
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
            return _managedObjectModel
        }
    }
    
    //MARK: - NSPersistentStoreCoordinator
    private var _presistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var presistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            if _presistentStoreCoordinator == nil {
                guard let model = self.managedObjectModel else {
                    print("Empty managed object model!")
                    return nil
                }
                _presistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                
                do {
                    try _presistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                        configurationName: nil,
                                                                        at: storeURL,
                                                                        options: nil)
                } catch {
                    assert(false, "Error adding persistent store to coordinator: \(error)")
                }
            }
            return _presistentStoreCoordinator
        }
    }
    
    //MARK: NSManagedObjectContext
    private var _masterContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let persistentStoreCoordinator = self.presistentStoreCoordinator else {
                    print("Empty persistent store coordinator!")
                    return nil
                }
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            return _masterContext
        }
    }
    
    private var _mainContext: NSManagedObjectContext?
    public var mainContext: NSManagedObjectContext? {
        get {
            if _mainContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("No master context!")
                    return nil
                }
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            return _mainContext
        }
    }
    
    private var _saveContext: NSManagedObjectContext?
    public var saveContext: NSManagedObjectContext? {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("No main context!")
                    return nil
                }
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            return _saveContext
        }
    }
    
    //MARK: Save context
    public func performSave(context: NSManagedObjectContext, completionHandler: (() -> Void)?) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
                
            }
        } else {
            completionHandler?()
        }
    }
    
    
    //MARK: getContexts
//    func getMasterContext() -> NSManagedObjectContext {
//        return self.masterContext!
//    }
//    
//    func getMainContext() -> NSManagedObjectContext {
//        return self.mainContext!
//    }
    
//    func getSaveContext() -> NSManagedObjectContext? {
//        return self.saveContext
//    }
    
//    func getCoreDataModel() -> NSManagedObjectModel {
//        return self.managedObjectModel!
//    }
}








