//
//  ConverstionListTableViewController.swift
//  TinkoffChat
//
//  Created by user on 26.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ConverstionListTableViewController: UITableViewController, ConversationsListServiceDelegate {
    
    var conversationListService: ConversationsListService?
    var conversationViewController: ConversationViewController?
    var emitter: Emitter?

    override func viewDidLoad() {
        super.viewDidLoad()
        conversationListService = ConversationsListService(tableView: tableView)
        conversationListService?.delegate = self
        emitter = Emitter(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversationViewController = nil
    }


    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let frc = conversationListService?.fetchedResultsController, let sectionsCount =
            frc.sections?.count else {
                return 0
        }
        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let frc = conversationListService?.fetchedResultsController, let sections = frc.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ConversationListCell{
            if let conversation = conversationListService?.fetchedResultsController?.object(at: indexPath) {
                cell.fillWithModel(model: conversation)
            }
            return cell
        }
        return ConversationListCell()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let frc = conversationListService?.fetchedResultsController, let sections = frc.sections else {
            return nil
        }
        if sections[section].name == "1" {
            return "ONLINE"
        } else {
            return "OFFLINE"
        }
    }

    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "Conversation") as? ConversationViewController {
            let conversation = conversationListService?.fetchedResultsController?.object(at: indexPath)
            vc.conversation = conversation
            conversationViewController = vc
            show(vc, sender: nil)
        }
    }
    
    func userChangeOnlineStatus(conversation: Conversation1, isOnline: Bool) {
        if conversationViewController != nil {
            if conversationViewController?.conversation == conversation {
                conversationViewController?.setOnlineStatus(isOnline: isOnline)
            }
        }
    }
}
