//
//  ConversationsListService.swift
//  TinkoffChat
//
//  Created by user on 13.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListService: NSObject {
    
    let fetchedResultsController: NSFetchedResultsController<Conversation1>?
    let tableView: UITableView
    let coreDataStack: CoreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    
    init(tableView: UITableView) {
        self.tableView = tableView
        let context = coreDataStack.mainContext!
        print("FETCHED CONTROLLER CONTEXT: \(context)")
        let fetchRequest: NSFetchRequest<Conversation1> = Conversation1.fetchRequest()
        let sortOnlineDescriptor: NSSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: false)
        let sortDateDescriptor: NSSortDescriptor = NSSortDescriptor(key: "lastMessage.date", ascending: true)
        let sortNameDescriptor: NSSortDescriptor = NSSortDescriptor(key: "user.name", ascending: true)
        fetchRequest.sortDescriptors = [sortOnlineDescriptor, sortDateDescriptor, sortNameDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        fetchedResultsController = NSFetchedResultsController<Conversation1>(fetchRequest:
            fetchRequest, managedObjectContext: context, sectionNameKeyPath: "isOnline",
                          cacheName: nil)
        super.init()
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
}

extension ConversationsListService: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("DELETE INDEXPATH: \(indexPath)")
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("INSERT INDEXPATH: \(newIndexPath)")
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                print("UPDATE INDEXPATH: \(indexPath)")
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex),
                                     with: .automatic)
            print("DELETE SECTION INDEX: \(sectionIndex)")
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex),
                                     with: .automatic)
            print("INSERT SECTION INDEX: \(sectionIndex)")
        case .move, .update: break
        }
    }
}

