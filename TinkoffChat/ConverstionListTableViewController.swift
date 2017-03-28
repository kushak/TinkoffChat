//
//  ConverstionListTableViewController.swift
//  TinkoffChat
//
//  Created by user on 26.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ConverstionListTableViewController: UITableViewController {
    
    var conversationsOnline = [Conversation]()
    var conversationsOffline = [Conversation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadConservations()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadConservations() {
        var conversations = [Conversation]()
        for i in 0..<20 {
            let conversation = Conversation()
            conversation.name = "User Name \(i)"
            conversation.message = "test message"
            conversation.date = Date.init(timeIntervalSinceNow: 0)
            conversation.online = Int(arc4random()) % 2 == 0 ? true:false
            conversation.hasUnreadMessage = Int(arc4random()) % 2 == 0 ? true:false
            conversations.append(conversation)
        }
        
        for conversation in conversations {
            if conversation.online! {
                conversationsOnline.append(conversation)
            } else {
                conversationsOffline.append(conversation)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? conversationsOnline.count : conversationsOffline.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ConversationListCell{
            cell.fillWithModel(model:
                indexPath.section == 0 ? conversationsOnline[indexPath.row]:conversationsOffline[indexPath.row])
            cell.initControls()
            return cell
        }
        
        
        return ConversationListCell()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "online" : "offline"
    }

    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "Conversation") as? ConversationViewController {
            vc.userName = indexPath.section == 0 ? conversationsOnline[indexPath.row].name:conversationsOffline[indexPath.row].name
            show(vc, sender: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
 

}
