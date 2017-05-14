//
//  ConversationService.swift
//  TinkoffChat
//
//  Created by user on 13.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import CoreData

protocol ConversationViewControllerProtocol {
    func sendMessage(text: String)
}

class ConversationService: NSObject, ConversationViewControllerProtocol, NSFetchedResultsControllerDelegate {

    let fetchedResultsController: NSFetchedResultsController<Message1>?
    let tableView: UITableView
    let coreDataStack: CoreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    let conversation: Conversation1
    
    init(tableView: UITableView, conversation: Conversation1) {
        self.tableView = tableView
        self.conversation = conversation
        let context = coreDataStack.mainContext!
        let fetchRequest: NSFetchRequest<Message1> = coreDataStack.managedObjectModel?.fetchRequestFromTemplate(withName: "MessagesForConversation", substitutionVariables: ["conversationId": conversation.conversationId!]) as! NSFetchRequest<Message1>
        let sortDateDescriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDateDescriptor]
        fetchedResultsController = NSFetchedResultsController<Message1>(fetchRequest:
            fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil,
                          cacheName: nil)
        super.init()
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    func sendMessage(text: String) {
        (UIApplication.shared.delegate as! AppDelegate).communicationManager?.sendMessage(string: text, to: (conversation.user?.userId)!, completionHandler: { (isSended, error) in
            if isSended {
                if let message: Message1 = NSEntityDescription.insertNewObject(forEntityName: "Message1", into: self.coreDataStack.mainContext!) as? Message1 {
                    message.text = text
                    message.conversation = self.conversation
                    message.messageId = Message1.generateID()
                    message.date = NSDate(timeIntervalSinceNow: 0.0)
                    self.conversation.user?.addToIncomingMessages(message)
                    self.coreDataStack.performSave(context: self.coreDataStack.mainContext!, completionHandler: nil)
                }
            }
        })
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        if let lastMessage = fetchedResultsController?.fetchedObjects?.last {
            if let lastIndexPatch = fetchedResultsController?.indexPath(forObject: lastMessage) {
                tableView.scrollToRow(at: lastIndexPatch, at: .bottom, animated: true)
            }
        }
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
