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
        registerForComunicatorManager()
        getConservations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForComunicatorManager()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewDidDisappear(animated)
    }
    
    func registerForComunicatorManager() {
        NotificationCenter.default.addObserver(self, selector: #selector(foundUser), name: NSNotification.Name(rawValue: "didFoundUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(lostUser), name: NSNotification.Name(rawValue: "didLostUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessage(_:)), name: NSNotification.Name(rawValue: "didReceiveMessage"), object: nil)
    }
    
    func foundUser() {
        getConservations()
    }
    
    func lostUser() {
        getConservations()
    }
    
    func receiveMessage(_ notification: NSNotification){
        let text = notification.userInfo?["text"] as! String
        let forConversation = notification.userInfo?["user"] as! String
        for conversation in conversationsOnline {
            if conversation.name! == forConversation {
                let message = Message(text: text, isInputMessage: true)
                message.date = Date.init(timeIntervalSinceNow: 0)
                conversation.messages.append(message)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func getConservations() {
//        conversationsOnline = CommunicationManager.sharedInstance.getPeers()
        DispatchQueue.main.async {
            self.conversationsOnline = CommunicationManager.sharedInstance.getPeers()
            self.tableView.reloadData()
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
            print(indexPath)
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
            vc.conversation = indexPath.section == 0 ? conversationsOnline[indexPath.row]:conversationsOffline[indexPath.row]
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
