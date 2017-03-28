//
//  ConversationListCell.swift
//  TinkoffChat
//
//  Created by user on 26.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell, ConversationCellConfiguration {

    var name: String?
    var message: String?
    var date: Date?
    var online: Bool?
    var hasUnreadMessage: Bool?
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    
    func fillWithModel(model: Conversation) {
        name = model.name
        message = model.message
        date = model.date
        online = model.online
        hasUnreadMessage = model.hasUnreadMessage
        
        initControls()
    }
    
    func initControls() {
        avatar.layoutIfNeeded()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
        avatar.image = UIImage.init(named: "User")
        userName.text = name
        if message != nil {
            if hasUnreadMessage! {
                messageText.font = UIFont.boldSystemFont(ofSize: 14)
            }
            messageText.text = message
        } else {
            messageText.text = "No messages yet"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        messageDate.text = dateFormatter.string(from: date!)
        if online! {
            self.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 210/255, alpha: 1)
        } else {
            self.backgroundColor = UIColor.white
        }
    }
    override func prepareForReuse() {
        avatar.image = nil
        userName.text = ""
        messageText.text = ""
        messageDate.text = ""
        self.backgroundColor = UIColor.clear
    }
}
